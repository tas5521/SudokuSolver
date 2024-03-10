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
    // View Presentation
    // カメラの表示を管理する変数
    @State private var isShowCamera: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                if let image = viewModel.image {
                    // 画像を表示
                    DragAndPinchImage(image: image)
                } // if let ここまで
                Rectangle()
                    .fill(Color.clear)
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 280, height: 280)
            } // ZStack ここまで
            Spacer()
            // カメラ表示ボタン
            Button {
                // カメラを表示
                isShowCamera.toggle()
            } label: {
                Text("Camera")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.buttonBlue)
                    .cornerRadius(5)
                    .foregroundStyle(Color.white)
                    .padding()
            } // Button ここまで
            .sheet(isPresented: $isShowCamera) {
                ImagePickerView(viewModel: $viewModel)
            } // sheet ここまで
            // フォトライブラリー表示ボタン
            PhotosPicker(selection: $viewModel.selectedPhoto) {
                Text("Photo Library")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.buttonBlue)
                    .cornerRadius(5)
                    .foregroundStyle(Color.white)
                    .padding()
            } // Button ここまで
            .onChange(of: viewModel.selectedPhoto) {
                Task {
                    // UIImageを取得
                    await viewModel.getUIImage()
                } // Task ここまで
            } // onChange ここまで
            // 数独読み込みボタン
            Button {
                // TODO: 数独を読み込む処理
            } label: {
                Text("Load Sudoku")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(viewModel.image == nil ? Color.gray : Color.buttonBlue)
                    .cornerRadius(5)
                    .foregroundStyle(Color.white)
                    .padding()
            } // Button ここまで
            // 画像が読み込まれていないときはボタンを押せなくする
            .disabled(viewModel.image == nil)
        } // VStack ここまで
    } // body ここまで
} // ScanSudokuView ここまで

#Preview {
    ScanSudokuView()
}
