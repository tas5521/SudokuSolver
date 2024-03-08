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
    // 処理中であるかどうかを管理する変数
    var isProcessing: Bool = false
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
    // ヒントを管理する変数
    var hintBoard: [[Bool]] = Array(repeating: Array(repeating: false, count: 9), count: 9)
    // 数独が初期条件を満たさない時の警告の表示を管理する変数
    var isShowInvalidAlert: Bool = false
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
    // 数独ソルバーのインスタンスを生成
    private let sudokuSolver: SudokuSolver = SudokuSolver()
    
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
    func pushSudokuIntoStack() {
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
    
    // 数独を解くメソッド
    // Viewの更新はメインスレッドで行う必要があるため、MainActorを指定
    @MainActor
    func solveSudoku() async {
        if sudoku == emptySudoku { return }
        // 数独ソルバーに現在の数独を渡す
        sudokuSolver.sudoku = sudoku
        guard sudokuSolver.isValidInitially() else {
            // 警告を表示
            isShowInvalidAlert = true
            return
        } // guard ここまで
        // 数独を解く
        if let solution = await sudokuSolver.solve() {
            pushSudokuIntoStack()
            // 一つでもヒントが指定されていた場合
            if hintBoard.flatMap({ $0 }).contains(true) {
                for row in 0..<9 {
                    for column in 0..<9 {
                        // ヒントが指定されているセルについてのみ、解を表示
                        if hintBoard[row][column] == true {
                            sudoku[row][column] = solution[row][column]
                        } // if ここまで
                    } // for ここまで
                } // for ここまで
            } else {
                // 一つもヒントが指定されてない場合、全ての解を表示
                sudoku = solution
            } // if ここまで
        } else {
            // キャンセルされた後、キャンセル状態をfalseに戻す
            sudokuSolver.resetCancel()
        } // if let ここまで
    } // solveSudoku ここまで
    
    // 数独を解くのをキャンセルするメソッド
    func cancelSolve() {
        sudokuSolver.cancelSolve()
    } // cancelSolve ここまで
    
    // 全てのヒントを解除するメソッド
    func resetAllHints() {
        hintBoard = Array(repeating: Array(repeating: false, count: 9), count: 9)
    } // resetAllHints ここまで
} // MainBoardViewModel
