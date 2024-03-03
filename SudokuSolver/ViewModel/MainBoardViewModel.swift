//
//  MainBoardViewModel.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/03.
//

import Foundation

@Observable
class MainBoardViewModel {
    // 選択されているボタンを管理する変数
    var selectedButton: ButtonType = .start
    // 数独を管理する変数
    var sudoku: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                           [0, 0, 0, 0, 0, 0, 0, 0, 0],
                           [0, 0, 0, 0, 0, 0, 0, 0, 0],
                           [0, 0, 0, 0, 0, 0, 0, 0, 0],
                           [0, 0, 0, 0, 0, 0, 0, 0, 0],
                           [0, 0, 0, 0, 0, 0, 0, 0, 0],
                           [0, 0, 0, 0, 0, 0, 0, 0, 0],
                           [0, 0, 0, 0, 0, 0, 0, 0, 0],
                           [0, 0, 0, 0, 0, 0, 0, 0, 0]]
    // Undoのための履歴を保持する変数
    private var sudokuStack: [[[Int]]] = []
    // 空の数独
    private let emptySudoku = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
                               [0, 0, 0, 0, 0, 0, 0, 0, 0],
                               [0, 0, 0, 0, 0, 0, 0, 0, 0],
                               [0, 0, 0, 0, 0, 0, 0, 0, 0],
                               [0, 0, 0, 0, 0, 0, 0, 0, 0],
                               [0, 0, 0, 0, 0, 0, 0, 0, 0],
                               [0, 0, 0, 0, 0, 0, 0, 0, 0],
                               [0, 0, 0, 0, 0, 0, 0, 0, 0],
                               [0, 0, 0, 0, 0, 0, 0, 0, 0]]
    
    // 数独の盤面に数字を入力するメソッド
    func enterNumberOnBoard(row: Int, column: Int) {
        let number = selectedButton.rawValue
        guard number < 10 else { return }
        pushSudokuIntoStack()
        sudoku[row][column] = number
    } // enterToBoard ここまで
    
    // 現在の数独をスタックに格納するメソッド
    func pushSudokuIntoStack() {
        sudokuStack.append(sudoku)
    } // pushIntoStackここまで
    
    // Undo（ひとつ前の盤面に戻す）を行うメソッド
    func undo() {
        // スタックからpop
        sudoku = sudokuStack.popLast() ?? emptySudoku
    } // undo ここまで
} // MainBoardViewModel
