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
    @State private var selectedButton: ButtonType = .start
    
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
                // 数字ボタンを配置
                numberButtons
                Spacer()
                HStack(spacing: 20) {
                    undoButton
                    clearButton
                    clearAllButton
                } // HStack ここまで
                HStack(spacing: 20) {
                    shareButton
                    hintButton
                    resetHintButton
                } // HStack ここまで
                HStack(spacing: 20) {
                    saveButton
                    listButton
                    solveButton
                } // HStack ここまで
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
                    // 選択された数字を保持
                    selectedButton = ButtonType(rawValue: number) ?? .clear
                } label: {
                    Text("\(number)")
                        .frame(width: 32, height: 32)
                        .background(selectedButton.rawValue == number ?
                                    Color.buttonOrange : Color.buttonBlue)
                        .cornerRadius(5)
                        .foregroundColor(Color.white)
                        .font(.title)
                } // Button ここまで
            } // ForEachここまで
        } // HStack ここまで
    } // numberButtons ここまで
    
    // Undo（ひとつ前の状態に戻る）ボタン
    private var undoButton: some View {
        Button {
            // TODO: Undo処理
        } label: {
            Text("Undo")
                .frame(width: 80, height: 32)
                .background(Color.buttonBlue)
                .cornerRadius(5)
                .foregroundColor(Color.white)
                .font(.title2)
        } // Button ここまで
    } // undoButton ここまで
    
    // クリアボタン
    private var clearButton: some View {
        Button {
            // Clearが選択されていることを保持
            selectedButton = .clear
        } label: {
            Text("Clear")
                .frame(width: 80, height: 32)
                .background(selectedButton == .clear ?
                            Color.buttonOrange : Color.buttonBlue)
                .cornerRadius(5)
                .foregroundColor(Color.white)
                .font(.title2)
        } // Button ここまで
    } // clearButon ここまで
    
    // 全てクリアするボタン
    private var clearAllButton: some View {
        Button {
            // TODO: 全てクリアする処理
        } label: {
            Text("Clear All")
                .frame(width: 120, height: 32)
                .background(Color.buttonBlue)
                .cornerRadius(5)
                .foregroundColor(Color.white)
                .font(.title2)
        } // Button ここまで
    } // clearAllButtonここまで
    
    // 数独の盤面を保存するボタン
    private var saveButton: some View {
        Button {
            // TODO: 数独の盤面を保存する処理
        } label: {
            Text("Save")
                .frame(width: 80, height: 32)
                .background(Color.buttonBlue)
                .cornerRadius(5)
                .foregroundColor(Color.white)
                .font(.title2)
        } // Button ここまで
    } // saveButton ここまで
    
    // 数独リストを表示するボタン
    private var listButton: some View {
        Button {
            // TODO: 数独リスト画面の表示
        } label: {
            Text("List")
                .frame(width: 80, height: 32)
                .background(Color.buttonBlue)
                .cornerRadius(5)
                .foregroundColor(Color.white)
                .font(.title2)
        } // Button ここまで
    } // listButton ここまで
    
    // 数独を解くボタン
    private var solveButton: some View {
        Button {
            
        } label: {
            Text("Solve")
                .frame(width: 120, height: 32)
                .background(Color.buttonBlue)
                .cornerRadius(5)
                .foregroundColor(Color.white)
                .font(.title2)
        } // Button ここまで
    } // solveButton ここまで

    // ヒントボタン
    private var hintButton: some View {
        Button {
            selectedButton = .hint
        } label: {
            Text("Hint")
                .frame(width: 80, height: 32)
                .background(selectedButton == .hint ?
                            Color.buttonOrange : Color.buttonBlue)
                .cornerRadius(5)
                .foregroundColor(Color.white)
                .font(.title2)
        } // Button ここまで
    } // hintButton ここまで
    
    // 全てのヒントを解除するボタン
    private var resetHintButton: some View {
        Button {
            // TODO: 全てのヒントを解除する
        } label: {
            Text("Reset Hint")
                .frame(width: 120, height: 32)
                .background(Color.buttonBlue)
                .cornerRadius(5)
                .foregroundColor(Color.white)
                .font(.title2)
        } // Button ここまで
    } // resetHintButton ここまで
    
    // SNS等に数独の盤面をシェアするボタン
    private var shareButton: some View {
        Button {
            // TODO: シェア機能
        } label: {
            Text("Share")
                .frame(width: 80, height: 32)
                .background(Color.buttonBlue)
                .cornerRadius(5)
                .foregroundColor(Color.white)
                .font(.title2)
        } // Button ここまで
    } // shareButton ここまで
} // MainBoardView ここまで

#Preview {
    MainBoardView()
}
