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
        // ボタンタイプの数値を取得
        let number = selectedButton.rawValue
        // ボタンタイプが.hintもしくは.startの場合は何もしないで終了
        guard number < 10 else { return }
        // 盤面の状態を記録
        pushSudokuIntoStack()
        // 指定されたセルに数字を配置
        sudoku[row][column] = number
    } // enterToBoard ここまで
    
    // 現在の数独をスタックに格納するメソッド
    private func pushSudokuIntoStack() {
        // 数独のスタックに現在の状態を記録
        sudokuStack.append(sudoku)
    } // pushIntoStackここまで
    
    // Undo（ひとつ前の盤面に戻す）を行うメソッド
    func undo() {
        // スタックからpop
        sudoku = sudokuStack.popLast() ?? emptySudoku
    } // undo ここまで
    
    // 盤面の数字を全てクリアするメソッド
    func clearAll() {
        // 盤面の状態を記録
        pushSudokuIntoStack()
        // 現在の数独の状態に空の数独を渡す
        sudoku = emptySudoku
    } // clearAll ここまで
} // MainBoardViewModel
