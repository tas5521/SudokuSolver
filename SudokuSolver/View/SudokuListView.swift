//
//  SudokuListView.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/02.
//

import SwiftUI
import CoreData

struct SudokuListView: View {
    @Environment(\.managedObjectContext) private var context
    // View presentation
    @Binding var isShowList: Bool
    // ViewModel
    @Binding var viewModel: MainBoardViewModel
    // CoreDataからフェッチした数独
    @FetchRequest(
        entity: SudokuData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \SudokuData.date,
                                           ascending: false)],
        animation: .default)
    private var fetchedSudokus: FetchedResults<SudokuData>
    // 81個の0のString
    private let zeros = String(repeating: "0", count: 81)
    
    var body: some View {
        if fetchedSudokus.count > 0 {
            List {
                ForEach(fetchedSudokus, id: \.self) { sudokuData in
                    // 一次元の数独を二次元に変換
                    let sudoku = create2DSudoku(from: sudokuData.sudoku ?? zeros)
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            // 日付
                            Text("Date: \((sudokuData.date ?? Date()).formatted(date: .long, time: .omitted))")
                                .padding(.leading)
                            // 読み込みボタン
                            Text("Load")
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    // 現在の盤面の状態を保存
                                    viewModel.pushSudokuIntoStack()
                                    // 数独を読み込み
                                    viewModel.sudoku = sudoku
                                    // リスト画面を閉じる
                                    isShowList = false
                                } // onTapGesture ここまで
                                .foregroundColor(Color.buttonBlue)
                                .padding(.leading)
                            // 数独をリストから削除するボタン
                            Text("Remove")
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    // 数独を削除
                                    context.delete(sudokuData)
                                    do {
                                        // 削除を記録
                                        try context.save()
                                    } catch let error as NSError {
                                        print("\(error), \(error.userInfo)")
                                    }
                                } // onTapGesture ここまで
                                .foregroundColor(Color.buttonBlue)
                                .padding([.leading, .trailing])
                        } // HStack ここまで
                        sudokuBoardView(board: sudoku)
                    } // VStack ここまで
                } // ForEach ここまで
            } // List ここまで
        } else {
            Text("保存されている数独はありません。")
                .font(.title3)
        } // if ここまで
    } // body ここまで
    
    // 数独の盤面
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
        .scaleEffect(0.8)
    } // sudokuBoardView ここまで
    
    // 一次元の数独を二次元の数独に変換するメソッド
    private func create2DSudoku(from flattenSudoku: String) -> [[Int]] {
        var result: [[Int]] = []
        var row: [Int] = []
        for (index, character) in flattenSudoku.enumerated() {
            if let number = Int(String(character)) {
                row.append(number)
                if (index + 1) % 9 == 0 {
                    result.append(row)
                    row.removeAll()
                } // if ここまで
            } // if let ここまで
        } // for ここまで
        return result
    } // create2DSudoku ここまで
} // SudokuListView


#Preview {
    SudokuListView(isShowList: .constant(true), viewModel: .constant(MainBoardViewModel()))
}
