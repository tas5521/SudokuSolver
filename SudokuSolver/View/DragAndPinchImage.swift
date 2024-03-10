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
    
    // 画像のドラッグに関わる変数
    // 現在のオフセットを保持する変数
    @State var offset: CGSize = .zero
    // オフセットを調節した後の値
    @State var lastOffset: CGSize = .zero
    
    // 画像の拡大縮小に関わる変数
    // 現在のスケールを保持する変数
    @State private var scale: CGFloat = 1.0
    // スケールを調節した後の値
    @State private var lastScale: CGFloat = 1.0
    // スケールの最小値
    private let minimumScale: Double = 0.2
    // スケールの最大値
    private let maximumScale: Double = 5.0
    
    // 画像の回転に関わる変数
    // 現在の角度を保持する変数
    @State var angle: Angle = .zero
    // 角度を調節した後の値
    @State var lastAngle: Angle = .zero
    
    var body: some View {
        // 画像を表示
        Image(uiImage: image)
        // 画像のリサイズ
            .resizable()
        // 枠に合わせてリサイズ
            .scaledToFill()
        // 幅高さ280に指定
            .frame(width: 280, height: 280)
        // ドラッグ位置を調節
            .offset(offset)
        // スケールを調節
            .scaleEffect(scale)
        // 回転を調節
            .rotationEffect(angle, anchor: .center)
        // ジェスチャーを指定
            .gesture(dragGesture)
            .gesture(SimultaneousGesture(scaleGuesture, rotateGesture))
    } // body ここまで
    
    // 画像のドラッグ
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged {
                offset = CGSize(width: lastOffset.width + $0.translation.width, height: lastOffset.height + $0.translation.height)
            } // onChanged ここまで
            .onEnded { _ in
                lastOffset = offset
            } // onEnded ここまで
    } // dragGesture ここまで
    
    // 画像の拡大縮小
    var scaleGuesture: some Gesture {
        MagnificationGesture()
            .onChanged {
                if ($0 > minimumScale) && ($0 < maximumScale) {
                    scale = $0 * lastScale
                } // if ここまで
            } // onChanged ここまで
            .onEnded { _ in
                lastScale = scale
            } // onEnded ここまで
    } // scaleGuesture ここまで
    
    // 画像の回転
    var rotateGesture: some Gesture {
        RotationGesture(minimumAngleDelta: .degrees(1))
            .onChanged {
                angle = $0 + lastAngle
            } // onChanged ここまで
            .onEnded { _ in
                lastAngle = angle
            } // onEnded ここまで
    } // rotateGesture ここまで
} // DragAndPinchImage ここまで
