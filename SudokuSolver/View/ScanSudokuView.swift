//
//  ScanSudokuView.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/03.
//

import SwiftUI
import PhotosUI

struct ScanSudokuView: View {
    // ScanSudokuViewModelのインスタンス
    @State private var viewModel: ScanSudokuViewModel = ScanSudokuViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                    // 画像のリサイズ
                        .resizable()
                    // 横幅
                        .scaledToFit()
                    // 幅高さ280に指定
                        .frame(width: 280, height: 280)
                } // 画像を表示
                Rectangle()
                    .fill(Color.clear)
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 280, height: 280)
            } // ZStack ここまで
            Spacer()
            // カメラ表示ボタン
            Button {
                // TODO: カメラを表示
            } label: {
                Text("Camera")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.buttonBlue)
                    .cornerRadius(5)
                    .foregroundColor(Color.white)
                    .padding()
            } // Button ここまで
            // フォトライブラリー表示ボタン
            PhotosPicker(selection: $viewModel.selectedPhoto) {
                Text("Photo Library")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.buttonBlue)
                    .cornerRadius(5)
                    .foregroundColor(Color.white)
                    .padding()
            } // Button ここまで
            .onChange(of: viewModel.selectedPhoto) {
                Task {
                    // UIImageを取得
                    await viewModel.getUIImage()
                } // Task ここまで
            } // onChange ここまで
        } // VStack ここまで
    } // body ここまで
} // ScanSudokuView ここまで

#Preview {
    ScanSudokuView()
}
