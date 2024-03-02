//
//  MainBoardView.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/02.
//

import SwiftUI

struct MainBoardView: View {
    // 数独を管理する変数
    @State private var sudoku: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                                          [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                          [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                          [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                          [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                          [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                          [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                          [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                          [0, 0, 0, 0, 0, 0, 0, 0, 0]]
    
    // 選択されているボタンを管理する変数
    @State private var selectedButton: ButtonType = .clear
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                HStack {
                    // タイトル
                    Text("Sudoku Solver")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    // カメラ画面の画面遷移
                    NavigationLink {
                        // TODO: カメラ画面のViewを配置
                    } label: {
                        Image(systemName: "camera.fill")
                            .foregroundStyle(Color.buttonBlue)
                            .scaleEffect(1.5)
                    } // NavigationLink ここまで
                } // HStack ここまで
                .padding(.leading, 15)
                .padding(.trailing, 25)
                Spacer()
                // 数独の盤面を配置
                board
                Spacer()
                numberButtons
                Spacer()
            } // VStack ここまで
        } // NavigationStack
    } // body ここまで
    
    // 数独の盤面
    private var board: some View {
        VStack(spacing: -1) {
            ForEach(0...8, id: \.self) { row in
                HStack(spacing: -1) {
                    ForEach(0...8, id: \.self) { column in
                        // セル内の数字を取得
                        let number = sudoku[row][column]
                        Button {
                        } label: {
                            // 0だったら表示しない
                            Text(number == 0 ? "" : String(number))
                                .frame(width: 40, height: 40)
                                .border(Color.black, width: 1)
                            // 背景色を白とグレーに分ける
                                .background(
                                    Group {
                                        if (row / 3 != 1 && column / 3 != 1) || (row / 3 == 1 && column / 3 == 1) {
                                            Color.white
                                        } else {
                                            Color.boardGray
                                        } // if ここまで
                                    } // Group ここまで
                                ) // background ここまで
                                .foregroundColor(Color.black)
                                .font(.title)
                        } // Button ここまで
                    } // ForEach ここまで
                } // HStack ここまで
            } // ForEach ここまで
        } // VStack ここまで
    } // board ここまで
    
    // 数字ボタン
    private var numberButtons: some View {
        HStack {
            ForEach(1...9, id: \.self) { number in
                Button {
                    
                } label: {
                    Text("\(number)")
                        .frame(width: 32, height: 32)
                        .background(Color.buttonBlue)
                        .cornerRadius(5)
                        .foregroundColor(Color.white)
                        .font(.title)
                } // Button ここまで
            } // ForEachここまで
        } // HStack ここまで
    } // numberButtons ここまで
} // MainBoardView ここまで

#Preview {
    MainBoardView()
}
