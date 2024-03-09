//
//  MainBoardViewModel.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/03.
//

import SwiftUI

@Observable
final class MainBoardViewModel {
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
    private let emptySudoku: [[Int]] = [[0, 0, 0, 0, 0, 0, 0, 0, 0],
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
        // 数独の盤面が空じゃないかチェック、空だったら終了
        if sudoku == emptySudoku { return }
        // 現在の盤面が数独の条件を満たすかチェック
        guard isValidInitially() else {
            // 条件を満たさなかったら警告を表示して終了
            isShowInvalidAlert = true
            return
        } // guard ここまで
        // 画面をロック
        isProcessing = true
        // ここから解き始める
        // 数独ソルバーに現在の数独を渡す
        sudokuSolver.sudoku = sudoku
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
            // 画面ロックを解除
            isProcessing = false
        } else {
            // キャンセルされた後、キャンセル状態をfalseに戻す
            sudokuSolver.resetCancel()
            // 画面ロックを解除
            isProcessing = false
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
    
    // 数独を解く前に、数独が条件を満たしているかを確認するメソッド
    private func isValidInitially() -> Bool {
        // 各行に重複がないかを確認
        for row in sudoku {
            var seen: Set<Int> = []
            for number in row {
                if number != 0 && seen.contains(number) {
                    return false
                } // if ここまで
                seen.insert(number)
            } // for ここまで
        } // for ここまで
        // 各列に重複がないかを確認
        for columnIndex in 0..<9 {
            var seen: Set<Int> = []
            for rowIndex in 0..<9 {
                let number = sudoku[rowIndex][columnIndex]
                if number != 0 && seen.contains(number) {
                    return false
                } // if ここまで
                seen.insert(number)
            } // for ここまで
        } // for ここまで
        // 各3×3のブロックに重複がないかを確認
        for i in 0..<3 {
            for j in 0..<3 {
                var seen: Set<Int> = []
                for rowIndex in i*3..<i*3+3 {
                    for columnIndex in j*3..<j*3+3 {
                        let number = sudoku[rowIndex][columnIndex]
                        if number != 0 && seen.contains(number) {
                            return false
                        } // if ここまで
                        seen.insert(number)
                    } // for ここまで
                } // for ここまで
            } // for ここまで
        } // for ここまで
        return true
    } // isValidInitially ここまで
    
    // 数独の盤面を画像に変換するメソッド
    @MainActor
    func getSudokuImage() -> UIImage {
        // 数独の盤面のViewを生成
        let sudokuBoardView = SudokuBoardView(board: sudoku)
        // Viewを画像にレンダリング
        if let image = sudokuBoardView.render() {
            // 画像を生成できたら、生成した画像を返却
            return image
        } // if letここまで
        // 画像を生成できなかったら、空の画像を返却
        return UIImage()
    } // getSudokuImage ここまで
} // MainBoardViewModel
