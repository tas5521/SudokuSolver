//
//  SudokuBoardView.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/09.
//

import SwiftUI

struct SudokuBoardView: View {
    // 数独の盤面
    let board: [[Int]]
    
    var body: some View {
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
                            .foregroundStyle(Color.black)
                            .font(.title)
                    } // ForEach ここまで
                } // HStack ここまで
            } // ForEach ここまで
        } // VStack
    } // VStack
    
    // Viewをレンダリングするメソッド
    @MainActor
    func render() -> UIImage? {
        let renderer = ImageRenderer(content: body)
        return renderer.uiImage
    } // render ここまで
} // SudokuBoardView ここまで
