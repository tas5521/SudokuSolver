//
//  DigitRecognizer.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/11.
//

import UIKit
import Vision

final class DigitRecognizer {
    // 数字を認識するメソッド
    static func recognizeDigits(in images: [UIImage]) -> String {
        // 認識された数字を格納するための文字列
        var recognizedDigits: String = ""
        // Core MLモデルの設定情報を保持するクラス。ここではデフォルトの設定を使用。
        let modelConfiguration = MLModelConfiguration()
        // MNISTModelのインスタンス
        guard let mnistModel = try? VNCoreMLModel(for: MNISTClassifier(configuration: modelConfiguration).model) else {
            return recognizedDigits
        } // guard let ここまで
        let request = VNCoreMLRequest(model: mnistModel) { request, error in
            // リクエスト中にエラーが発生した場合
            if let error {
                // デバッグエリアにメッセージを表示
                print("数字認識でエラーが発生しました: \(error)")
                return
            } //if letここまで
            // 画像内のオブジェクトに関する情報を取得し、[VNClassificationObservation]型にダウンキャスト
            guard let results = request.results as? [VNClassificationObservation] else { return }
            // 認識の結果の最初のものを取り出す
            guard let topResult = results.first else { return }
            // 認識された数字をわたす
            recognizedDigits += topResult.identifier
        } // request ここまで
        // CIImageに変換
        let ciImages: [CIImage] = images.map { CIImage(image: $0) ?? CIImage() }
        for ciImage in ciImages {
            // 画像に数字があるか判断
            if isThereDigit(in: ciImage) {
                do {
                    try VNImageRequestHandler(ciImage: ciImage).perform([request])
                } catch {
                    // エラーが出たら、デバッグエリアに表示
                    print("Visionリクエスト実行時にエラーが発生しました: \(error)")
                } // do-try-catch ここまで
            } else {
                recognizedDigits += "0"
            } // if ここまで
        } // for ここまで
        return recognizedDigits
    } // recognizeDigits ここまで
    
    /// 画像の各ピクセルデータの標準偏差を計算
    /// 標準偏差が小さければ（0に近ければ）、文字が入力されていないことになる。
    /// MNISTClassifierでの数字認識では、何も数字が書いていない時に1が出力されてしまうため、画像の各ピクセルデータの標準偏差から、
    /// 画像に数字が書いてあるされているかどうかを判断する。
    static private func isThereDigit(in ciImage: CIImage) -> Bool {
        // CIImageをCGImageに変換
        // Core Graphicsの機能を使用すれば、ピクセルデータに簡単にアクセスできる
        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent),
              // 各ピクセルの明るさを計算
              // ピクセルデータプロバイダーからデータを取得
                let pixelData = cgImage.dataProvider?.data,
              // CFDataGetBytePtrはCFDataオブジェクトから、UInt8ポインター（メモリ内のバイトデータを指すポインター）を取得する
              // ピクセルデータへのポインターを取得し、ピクセルデータに対して直接アクセスできるようになる
              let ptr = CFDataGetBytePtr(pixelData) else { return false }
        // 明るさの平均を計算するためのパラメータを指定
        let width = cgImage.width
        let height = cgImage.height
        // 各ピクセルの明るさを保持する変数
        var brightnesses: [Double] = []
        // 1ピクセルあたりのバイト数 (RGBA)
        let bytesPerPixel = 4
        for y in 0..<height {
            for x in 0..<width {
                let byteIndex = (bytesPerPixel * width * y) + (bytesPerPixel * x)
                let red = CGFloat(ptr[byteIndex]) / 255.0
                let green = CGFloat(ptr[byteIndex + 1]) / 255.0
                let blue = CGFloat(ptr[byteIndex + 2]) / 255.0
                let alpha = CGFloat(ptr[byteIndex + 3]) / 255.0
                // 輝度を計算（明るさを計算するための標準的な重みづけ係数をかけている）
                let brightness = (red * 0.299 + green * 0.587 + blue * 0.114) * alpha
                // 1ピクセルの明るさを保持
                brightnesses.append(Double(brightness))
            } // for ここまで
        } // for ここまで
        // 総ピクセル数
        let pixelCount = Double(width * height)
        // 明るさの平均
        let averageBrightness = brightnesses.reduce(0, +) / pixelCount
        // 明るさの標準偏差
        let standardBrightness = sqrt(brightnesses.map({ pow( Double($0) - averageBrightness, 2.0) }).reduce(0, +) / pixelCount)
        // 明るさの標準偏差が基準（0.01）より上だったら、数字があると判断
        if standardBrightness > 0.01 {
            // 数字あり
            return true
        } else {
            // 数字なし
            return false
        } // if ここまで
    } // calculateContrast ここまで
} // DigitRecognizer ここまで
