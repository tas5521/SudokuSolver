//
//  UIViewExtension.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/10.
//

import UIKit

// UIViewを拡張
extension UIView {
    // RectをもとにUIImageを生成するgetImageメソッドを追加
    func getImage(rect: CGRect) -> UIImage {
        // 指定されたRectでUIImageを生成するためのrendererを作成
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        // UIImageを返す
        return renderer.image { context in
            // layerには、ビューの内容を描画するための情報が格納されている
            // UIView内のすべてのビューやグラフィックをキャプチャ
            layer.render(in: context.cgContext)
        } // renderer.imageここまで
    } // getImageここまで
} // UIView拡張ここまで
