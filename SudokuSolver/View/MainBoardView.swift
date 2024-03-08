//
//  MainBoardView.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/02.
//

import SwiftUI

struct MainBoardView: View {
    @Environment(\.managedObjectContext) private var context
    // View presentation
    // リスト画面の表示を管理する変数
    @State private var isShowList: Bool = false
    // 数独を保存したことを伝えるメッセージの表示を管理すつ変数
    @State private var isShowSaveMessage: Bool = false
    
    // ViewModel
    @State private var viewModel: MainBoardViewModel = MainBoardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                    Spacer()
                } // VStack ここまで
                // 計算処理中だったら、インジケータを表示
                if viewModel.isProcessing {
                    Color.gray.opacity(0.3)
                        .ignoresSafeArea()
                    VStack {
                        ProgressView("処理中です\nしばらくお待ち下さい")
                        // キャンセルボタンを配置
                        Button {
                            // キャンセルを実行
                            viewModel.cancelSolve()
                        } label: {
                            Text("Cancel")
                                .padding()
                        } // Button ここまで
                    } // VStack ここまで
                } // if ここまで
            } // ZStack ここまで
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
                            // ヒントボタンが選択されていたら、
                            if viewModel.selectedButton == .hint {
                                viewModel.hintBoard[row][column].toggle()
                            } // if ここまで
                        } label: {
                            // 0だったら表示しない
                            Text(number == 0 ? "" : String(number))
                                .frame(width: 40, height: 40)
                                .border(Color.black, width: 1)
                            // 背景色を指定
                                .background(
                                    Group {
                                        if viewModel.hintBoard[row][column] {
                                            Color.buttonOrange
                                        } else if (row / 3 != 1 && column / 3 != 1) || (row / 3 == 1 && column / 3 == 1) {
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
        .padding()
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
            // 盤面の数字を全てクリアする
            viewModel.clearAll()
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
    @ViewBuilder
    @MainActor
    private var shareButton: some View {
        let sudokuImage = ImageRenderer(content: board).uiImage ?? UIImage()
        ShareLink(
            item: Image(uiImage: sudokuImage),
            subject: nil,
            message: nil,
            preview: SharePreview("Sudoku", image: Image(uiImage: sudokuImage))
        ) {
            Text("Share")
                .frame(width: 80, height: 32)
                .background(Color.buttonBlue)
                .cornerRadius(5)
                .foregroundColor(Color.white)
                .font(.title2)
        } // ShareLink ここまで
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
            // 数独の盤面を保存する処理
            saveSudoku()
            // 数独を保存したことをユーザーに伝えるメッセージ
            isShowSaveMessage.toggle()
        } label: {
            Text("Save")
                .frame(width: 80, height: 32)
                .background(Color.buttonBlue)
                .cornerRadius(5)
                .foregroundColor(Color.white)
                .font(.title2)
        } // Button ここまで
        .alert(isPresented: $isShowSaveMessage) {
            Alert(title: Text("数独をリストに保存しました。"))
        } // alert ここまで
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
            SudokuListView(isShowList: $isShowList, viewModel: $viewModel)
        } // sheet ここまで
    } // listButton ここまで
    
    // 数独を解くボタン
    private var solveButton: some View {
        Button {
            viewModel.isProcessing = true
            Task {
                // 数独を解く
                await viewModel.solveSudoku()
                viewModel.isProcessing = false
            } // Task ここまで
        } label: {
            Text("Solve")
                .frame(width: 120, height: 32)
                .background(Color.buttonBlue)
                .cornerRadius(5)
                .foregroundColor(Color.white)
                .font(.title2)
        } // Button ここまで
        .alert(isPresented: $viewModel.isShowInvalidAlert) {
            Alert(title: Text("数独が条件を満たしていません"))
        } // alert ここまで
    } // solveButton ここまで
    
    // 現在の盤面を保存するメソッド
    private func saveSudoku() {
        // CoreDataのインスタンスを作成
        let sudokuData = SudokuData(context: context)
        // 数独を一次元の文字列に変換し、インスタンスに渡す
        sudokuData.sudoku = viewModel.sudoku.flatMap { $0 }.map { String($0) }.joined()
        // 保存した日付をインスタンスに渡す
        sudokuData.date = Date()
        do {
            // データを保存
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        } // do-try-catch ここまで
    } // saveSudoku ここまで
} // MainBoardView ここまで

#Preview {
    MainBoardView()
}
