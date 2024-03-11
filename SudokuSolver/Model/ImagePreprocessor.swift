//
//  ImagePreprocessor.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/10.
//

import UIKit

final class ImagePreprocessor {
    // 前処理するメソッド
    static func preprocess(image: UIImage) -> [UIImage] {
        // 数独の画像の各セルを取得
        let cellImages = getEachCell(from: image)
        // 画像を28x28ピクセルにリサイズ
        let resizedImages = resizeTo28x28(images: cellImages)
        // 画像をグレースケールに変換
        let grayScaledImages = convertToGrayScale(images: resizedImages)
        // 白黒反転
        return invertColor(images: grayScaledImages)
    } // preprocess ここまで
    
    // 数独の画像の各セルを取得するメソッド
    static private func getEachCell(from image: UIImage) -> [UIImage] {
        // 枠をどの程度除外するかの基準
        // 枠が含まれていると文字認識に影響が出てしまうので、画像から除外する
        let criterion: CGFloat = CGFloat(0.15)
        // セルの幅を取得
        let cellWidth: CGFloat = image.size.width / CGFloat(4.5)
        // セルの画像を格納する配列
        var cellImages: [UIImage] = []
        // 各セルからUIImageを取得
        for row in 0..<9 {
            for column in 0..<9 {
                let cellRect = CGRect(x: cellWidth * (CGFloat(Double(column) + criterion)),
                                      y: cellWidth * (CGFloat(Double(row) + criterion)),
                                      width: cellWidth * CGFloat(1.0 - 2 * criterion),
                                      height: cellWidth * CGFloat(1.0 - 2 * criterion))
                guard let cellImage = image.cgImage?.cropping(to: cellRect) else { return [] }
                cellImages.append(UIImage(cgImage: cellImage))
            } // for ここまで
        } // for ここまで
        return cellImages
    } // getEachCell ここまで
    
    // 画像を28x28ピクセルにリサイズするメソッド
    static private func resizeTo28x28(images: [UIImage]) -> [UIImage] {
        // 目標のピクセルサイズ（28）
        let targetSize = CGSize(width: 28, height: 28)
        // 新しい描画コンテキストのサイズ（リサイズ後の画像のサイズ）を指定
        UIGraphicsBeginImageContextWithOptions(targetSize, false, UIScreen.main.scale)
        let resizedImages = images.map { image in
            // 指定したrect内に元の画像が収まるように縮小
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            // リサイズされた画像を取得
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                return image
            } else {
                return UIImage()
            } // if let ここまで
        } // resizedImages ここまで
        // 描画コンテキストをクリアして解放する（描画コンテキストをメモリ内から解放し、リソースのリークを防ぐため）
        UIGraphicsEndImageContext()
        return resizedImages
    } // resizeImages ここまで
    
    // 画像をグレースケールに変換するメソッド
    static private func convertToGrayScale(images: [UIImage]) -> [UIImage] {
        images.map { image in
            // UIImageをCIImageに変換
            let ciImage = CIImage(image: image)
            // グレースケールにするためのフィルターを作成
            guard let filter = CIFilter(name: "CIColorControls") else { return UIImage() }
            // フィルターに画像をセット
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            // 彩度を完全に除去し、画像をグレースケールに変換
            filter.setValue(0.0, forKey: kCIInputSaturationKey)
            // フィルターをした画像を取得
            guard let outputImage = filter.outputImage else { return UIImage() }
            // cgImageを取得
            guard let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else { return UIImage() }
            // cgImageをUIImageに変換して返却
            return UIImage(cgImage: cgImage)
        } // map ここまで
    } // convertToGrayScale ここまで
    
    // 白黒反転するメソッド
    static private func invertColor(images: [UIImage]) -> [UIImage] {
        images.map { image in
            // cgImageを取得
            guard let cgImage = image.cgImage else { return UIImage() }
            // 画像の幅と高さを取得
            let width = cgImage.width
            let height = cgImage.height
            //
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            // CGContextを生成
            guard let context = CGContext(
                // ピクセルデータのメモリへのポインタ ここでは使用しない
                data: nil,
                // 描画する画像の幅（ピクセル単位）
                width: width,
                // 描画する画像の高さ（ピクセル単位）
                height: height,
                // 画像の各色成分ごとのビット数。通常は8ビット（1バイト）。
                bitsPerComponent: 8,
                // 画像の各行のバイト数。
                // ここでは width に4を掛けた値を使用。
                // 1ピクセルあたりの色成分数はRGBAの4つで、各色成分は8ビット（1バイト）で表現されるため、width（行のピクセル数）に4バイトをかける
                bytesPerRow: width * 4,
                // 画像の色空間を示すCGColorSpaceオブジェクト。ここではデバイスのRGB色空間が使用されている。
                space: colorSpace,
                // 画像のビットマップの特性を示す値。
                // CGImageAlphaInfo.noneSkipLast.rawValue は、アルファチャンネルを持たず、ピクセルの並び順が逆転していることを示している。
                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
            ) else { return UIImage() }
            // cgImageを描画
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            // context.dataを使用して、ピクセルデータを取得
            if let buffer = context.data {
                // bufferが指すメモリ領域をUInt8型のメモリとして解釈し、そのポインタをpixelBufferにバインドする
                let pixelBuffer = buffer.bindMemory(to: UInt8.self, capacity: width * height * 4)
                for number in 0..<(width * height * 4) {
                    // 白黒反転
                    pixelBuffer[number] = 255 - pixelBuffer[number]
                } // for ここまで
                // 画像を作成
                if let invertedCGImage = context.makeImage() {
                    // UIImageに変換し、返却
                    let invertedImage = UIImage(cgImage: invertedCGImage)
                    return invertedImage
                } // if let ここまで
            } // if let ここまで
            return UIImage()
        } // map ここまで
    } // invertColor ここまで
} // ImagePreprocessor ここまで
