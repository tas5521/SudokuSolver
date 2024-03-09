//
//  SudokuSolver.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/05.
//

import Foundation

// 数独のソルバー
class SudokuSolver {
    // 数独ボード
    var sudoku: [[Int]] = []
    // キャンセルされたかどうかを管理する変数
    private var isCancelled: Bool = false
    
    // 数独を解くメソッド
    func solve() async -> [[Int]]? {
        // キャンセルトークンがキャンセルされているかを確認
        if isCancelled { return nil }
        // 空のセルを探す
        var emptyCell: (Int, Int)? = nil
        for i in 0..<9 {
            for j in 0..<9 {
                if sudoku[i][j] == 0 {
                    emptyCell = (i, j)
                    break
                } // if ここまで
            } // for ここまで
            if emptyCell != nil {
                break
            } // if ここまで
        } // for ここまで
        // 空のセルが見つからない場合、数独が解けたことになる
        if emptyCell == nil {
            return sudoku
        } // if ここまで
        // 空のセルに数字を割り当てて解を探索
        let (row, column) = emptyCell!
        for number in 1...9 {
            if isValid(row: row, column: column, number: number) {
                sudoku[row][column] = number
                // 再帰的に次のセルを解く
                if let solution = await solve() {
                    return solution
                } // if let ここまで
                // 解が見つからない場合は戻って元に戻す
                sudoku[row][column] = 0
            } // if ここまで
        } // for ここまで
        // このセルに対してどの数字も有効でない場合は、この解法は失敗
        return nil
    } // solveSudoku ここまで
    
    // 数字を割り当てることができるかをチェックするメソッド
    private func isValid(row: Int, column: Int, number: Int) -> Bool {
        // 同じ行に同じ数字がないかをチェック
        for i in 0..<9 {
            if sudoku[row][i] == number {
                return false
            } // if ここまで
        } // for ここまで
        // 同じ列に同じ数字がないかをチェック
        for i in 0..<9 {
            if sudoku[i][column] == number {
                return false
            } // if ここまで
        } // for ここまで
        // 同じ3x3のブロックに同じ数字がないかをチェック
        let startRow = (row / 3) * 3
        let startColumn = (column / 3) * 3
        for i in startRow..<startRow + 3 {
            for j in startColumn..<startColumn + 3 {
                if sudoku[i][j] == number {
                    return false
                } // if ここまで
            } // for j ここまで
        } // for i ここまで
        return true
    } // isValid ここまで

    // 数独を解くのをキャンセルするメソッド
    func cancelSolve() {
        isCancelled = true
    } // cancelSolve ここまで
    
    // キャンセルされているかどうかをリセットするメソッド
    func resetCancel() {
        isCancelled = false
    } // resetCancel ここまで
} // SudokuSolver ここまで
