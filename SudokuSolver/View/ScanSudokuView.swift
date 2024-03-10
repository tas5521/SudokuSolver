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
        ZStack {
            VStack {
                Spacer()
                Group {
                    GeometryReader { geometry in
                        if let image = viewModel.image {
                            // 画像を表示
                            DragAndPinchImage(image: image)
                            // 画像が表示された時にフレームの座標とサイズを取得
                                .onAppear {
                                    viewModel.frameRect = geometry.frame(in: .global)
                                } // onAppear ここまで
                        } // if let ここまで
                    } // GeometryReader ここまで
                } // Group ここまで
                .frame(width: 280, height: 280)
                .border(Color.blue, width: 2)
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
                } // Button ここまで
                .onChange(of: viewModel.selectedPhoto) {
                    Task {
                        // UIImageを取得
                        await viewModel.getUIImage()
                    } // Task ここまで
                } // onChange ここまで
                // 数独読み込みボタン
                Button {
                    // 枠内を画像化
                    viewModel.getImageInsideFrame()
                } label: {
                    Text("Load Sudoku")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(viewModel.image == nil ? Color.gray : Color.buttonBlue)
                        .cornerRadius(5)
                        .foregroundStyle(Color.white)
                } // Button ここまで
                // 画像が読み込まれていないときはボタンを押せなくする
                .disabled(viewModel.image == nil)
            } // VStack ここまで
            .padding()
            if let imageInsideFrame = viewModel.imageInsideFrame {
                Image(uiImage: imageInsideFrame)
            } // if let ここまで
        } // ZStack ここまで
    } // body ここまで
} // ScanSudokuView ここまで

#Preview {
    ScanSudokuView()
}
