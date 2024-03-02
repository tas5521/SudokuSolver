//
//  SudokuListView.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/02.
//

import SwiftUI

struct SudokuListView: View {
    @Binding var isShowList: Bool
    // ダミーの数独を管理する変数
    private let dummySudoku: [[[Int]]] = [
        [[0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0]],
        [[0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0, 0]]
    ]
    
    var body: some View {
        List {
            ForEach(dummySudoku, id: \.self) { sudoku in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        // 日付
                        Text("Date: \(Date().formatted(date: .long, time: .omitted))")
                            .padding(.leading)
                        // 読み込みボタン
                        Text("Load")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                
                            } // onTapGesture ここまで
                            .foregroundColor(Color.buttonBlue)
                            .padding(.leading)
                        // 数独をリストから削除するボタン
                        Text("Remove")
                            .foregroundColor(.blue)
                            .onTapGesture {
                            } // onTapGesture ここまで
                            .foregroundColor(Color.buttonBlue)
                            .padding([.leading, .trailing])
                    } // HStack ここまで
                    sudokuBoardView(board: sudoku)
                        .scaleEffect(0.8)
                } // VStack ここまで
            } // ForEach ここまで
        } // List ここまで
    } // body ここまで
    
    private func sudokuBoardView(board: [[Int]]) -> some View {
        VStack(spacing: -1) {
            ForEach(0..<9, id: \.self) { row in
                HStack(spacing: -1) {
                    ForEach(0..<9, id: \.self) { column in
                        let number = board[row][column]
                        Text(number == 0 ? "" : String(number))
                            .frame(width: 40, height: 40)
                            .border(Color.black, width: 1)
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
                    } // ForEach ここまで
                } // HStack ここまで
            } // ForEach ここまで
        } // VStack ここまで
    } // sudokuBoardView ここまで
} // SudokuListView


#Preview {
    SudokuListView(isShowList: .constant(true))
}
