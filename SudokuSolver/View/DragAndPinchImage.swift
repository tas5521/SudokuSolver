//
//  DragAndPinchImage.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/10.
//

import SwiftUI

struct DragAndPinchImage: View {
    // 画像を保持する変数
    let image: UIImage
    
    // 画像のスケーリングに関わる変数
    // 現在のスケールを保持する変数
    @State private var scale: CGFloat = 1.0
    // スケールを調節した後の値
    @State private var lastScale: CGFloat = 1.0
    // スケールの最小値
    private let minimumScale: Double = 0.2
    // スケールの最大値
    private let maximumScale: Double = 5.0
    
    var body: some View {
        // 画像を表示
        Image(uiImage: image)
        // 画像のリサイズ
            .resizable()
        // 枠に合わせてリサイズ
            .scaledToFill()
        // 幅高さ280に指定
            .frame(width: 280, height: 280)
        // スケールを調節
            .scaleEffect(scale)
        // ジェスチャーを指定
            .gesture(scaleGuesture)
    } // body ここまで
    
    // 画像のスケーリング
    var scaleGuesture: some Gesture {
        MagnificationGesture()
            .onChanged {
                if ($0 > minimumScale) && ($0 < maximumScale) {
                    scale = $0 * lastScale
                } // if ここまで
            } // onChanged ここまで
            .onEnded{ _ in
                lastScale = scale
            } // onEnded ここまで
    } // scaleGuesture ここまで
} // DragAndPinchImage ここまで
