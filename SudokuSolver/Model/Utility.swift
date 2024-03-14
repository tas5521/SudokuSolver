//
//  Utility.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/11.
//

import Foundation

class Utility {
    // 一次元の数独を二次元の数独に変換するメソッド
    static func create2DSudoku(from flattenSudoku: String) -> [[Int]] {
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
} // Utility ここまで
