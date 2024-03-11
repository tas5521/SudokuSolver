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
        }
        let request = VNCoreMLRequest(model: mnistModel) { request, error in
            // リクエスト中にエラーが発生した場合
            if let error {
                // デバッグエリアにメッセージを表示
                print("数字認識でエラーが発生しました: \(error)")
                return
            } //if letここまで
            // 画像内のオブジェクトに関する情報を取得し、[VNClassificationObservation]型にダウンキャスト
            guard let results = request.results as? [VNClassificationObservation] else { return }
            //
            guard let classification = results.first else { return }
            //
            recognizedDigits += classification.identifier
        } // request ここまで
        
        // CIImageに変換
        let ciImages: [CIImage] = images.map { CIImage(image: $0) ?? CIImage() }

        for ciImage in ciImages {
            // 画像のコントラストを計算
            let contrast = self.calculateContrast(of: ciImage)
            if contrast > 0.1 {
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
    
    // 画像のコントラストを計算
    static private func calculateContrast(of ciImage: CIImage) -> Double {
        // 1. 画像をグレースケールに変換
        guard let filter = CIFilter(name: "CIColorControls") else { return 0.0 }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0.0, forKey: kCIInputSaturationKey)
        if let outputImage = filter.outputImage,
           let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
            // 2. 各ピクセルの明るさを計算
            guard let pixelData = cgImage.dataProvider?.data,
                  let ptr = CFDataGetBytePtr(pixelData) else {
                return 0.0
            }
            let bytesPerPixel = 4 // 1ピクセルあたりのバイト数 (RGBA)
            let width = cgImage.width
            let height = cgImage.height
            var totalBrightness: Double = 0.0
            // 3. 明るさの平均を計算
            for y in 0..<height {
                for x in 0..<width {
                    let byteIndex = (bytesPerPixel * width * y) + (bytesPerPixel * x)
                    let alpha = CGFloat(ptr[byteIndex + 3]) / 255.0
                    let red = CGFloat(ptr[byteIndex]) / 255.0
                    let green = CGFloat(ptr[byteIndex + 1]) / 255.0
                    let blue = CGFloat(ptr[byteIndex + 2]) / 255.0
                    // 輝度を計算（明るさを重み付け）
                    let brightness = (red * 0.299 + green * 0.587 + blue * 0.114) * alpha
                    totalBrightness += Double(brightness)
                }
            }
            // 4. コントラストを計算
            let pixelCount = Double(width * height)
            let averageBrightness = totalBrightness / pixelCount
            var totalContrast: Double = 0.0
            for y in 0..<height {
                for x in 0..<width {
                    let byteIndex = (bytesPerPixel * width * y) + (bytesPerPixel * x)
                    let alpha = CGFloat(ptr[byteIndex + 3]) / 255.0
                    let red = CGFloat(ptr[byteIndex]) / 255.0
                    let green = CGFloat(ptr[byteIndex + 1]) / 255.0
                    let blue = CGFloat(ptr[byteIndex + 2]) / 255.0
                    // 輝度を計算（明るさを重み付け）
                    let brightness = (red * 0.299 + green * 0.587 + blue * 0.114) * alpha
                    // コントラストを計算
                    let contrast = pow(Double(brightness) - averageBrightness, 2.0)
                    totalContrast += contrast
                }
            }
            // コントラストを正規化して返す
            let normalizedContrast = sqrt(totalContrast / pixelCount)
            return normalizedContrast
        }
        return 0.0
    } // calculateContrast ここまで
} // DigitRecognizer ここまで
