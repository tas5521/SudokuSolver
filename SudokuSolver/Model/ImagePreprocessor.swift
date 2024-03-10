//
//  ImagePreprocessor.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/10.
//

import UIKit

final class ImagePreprocessor {
    // 処理前の画像
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    } // init ここまで
    
    // 前処理するメソッド
    func preprocess() -> [UIImage] {
        getEachCell(from: image)
    } // preprocess ここまで
    
    // 数独の画像の各セルを取得
    private func getEachCell(from image: UIImage) -> [UIImage] {
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
} // ImagePreprocessor ここまで
