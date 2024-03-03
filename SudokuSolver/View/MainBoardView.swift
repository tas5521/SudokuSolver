//
//  MainBoardView.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/02.
//

import SwiftUI

struct MainBoardView: View {
    // View presentation
    // リスト画面の表示を管理する変数
    @State private var isShowList: Bool = false
    
    // ViewModel
    @State private var viewModel: MainBoardViewModel = MainBoardViewModel()
    
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
                        // 数独スキャン画面へ遷移
                        ScanSudokuView()
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
                    // Undo（ひとつ前の状態に戻る）ボタンを配置
                    undoButton
                    // クリアボタンを配置
                    clearButton
                    // 全てクリアするボタンを配置
                    clearAllButton
                } // HStack ここまで
                HStack(spacing: 20) {
                    // SNS等に数独の盤面をシェアするボタンを配置
                    shareButton
                    // ヒントボタン
                    hintButton
                    // 全てのヒントを解除するボタンを配置
                    resetHintButton
                } // HStack ここまで
                HStack(spacing: 20) {
                    // 数独の盤面を保存するボタンを配置
                    saveButton
                    // 数独リストを表示するボタンを配置
                    listButton
                    // 数独を解くボタンを配置
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
                        let number = viewModel.sudoku[row][column]
                        Button {
                            // 選択されている数字を盤面に入力する
                            viewModel.enterNumberOnBoard(row: row, column: column)
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
                    viewModel.selectedButton = ButtonType(rawValue: number) ?? .clear
                } label: {
                    Text("\(number)")
                        .frame(width: 32, height: 32)
                        .background(viewModel.selectedButton.rawValue == number ?
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
            // Undo（ひとつ前の盤面に戻す）を行う
            viewModel.undo()
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
            viewModel.selectedButton = .clear
        } label: {
            Text("Clear")
                .frame(width: 80, height: 32)
                .background(viewModel.selectedButton == .clear ?
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
    
    // ヒントボタン
    private var hintButton: some View {
        Button {
            viewModel.selectedButton = .hint
        } label: {
            Text("Hint")
                .frame(width: 80, height: 32)
                .background(viewModel.selectedButton == .hint ?
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
            isShowList.toggle()
        } label: {
            Text("List")
                .frame(width: 80, height: 32)
                .background(Color.buttonBlue)
                .cornerRadius(5)
                .foregroundColor(Color.white)
                .font(.title2)
        } // Button ここまで
        .sheet(isPresented: $isShowList) {
            SudokuListView(isShowList: $isShowList)
        } // sheet ここまで
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
} // MainBoardView ここまで

#Preview {
    MainBoardView()
}
