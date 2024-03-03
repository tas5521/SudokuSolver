//
//  ScanSudokuView.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/03.
//

import SwiftUI

struct ScanSudokuView: View {
    
    var body: some View {
        VStack {
            Spacer()
            Rectangle()
                .fill(Color.clear)
                .stroke(Color.blue, lineWidth: 2)
                .frame(width: 280, height: 280)
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
            Button {
                // TODO: フォトライブラリーを表示
            } label: {
                Text("Photo Library")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.buttonBlue)
                    .cornerRadius(5)
                    .foregroundColor(Color.white)
                    .padding()
            } // Button ここまで
        } // VStack ここまで
    } // body ここまで
} // ScanSudokuView ここまで

#Preview {
    ScanSudokuView()
}
