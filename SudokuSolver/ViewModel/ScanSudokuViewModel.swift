//
//  ScanSudokuViewModel.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/09.
//

import SwiftUI
import PhotosUI

@Observable
final class ScanSudokuViewModel {
    // 選択された写真を保持する変数
    var selectedPhoto: PhotosPickerItem? = nil
    // 取得したUIImageを保持する変数
    var image: UIImage? = nil
    // フレームの座標とサイズの情報を保持する変数
    var frameRect: CGRect = .zero
    // 各セルのImageを保持する配列
    var images: [UIImage] = []
    
    @MainActor
    // PhotosPickerItemをUIImageに変換
    func getUIImage() async {
        if let selectedPhoto {
            do {
                guard let data = try await selectedPhoto.loadTransferable(type: Data.self) else { return }
                guard let uiImage = UIImage(data: data) else { return }
                image = uiImage
            } catch {
                print("PhotosPickerでエラーが発生しました: \(error)")
            } // do-try-catch ここまで
        } // if let ここまで
    } // getUIImage ここまで
    
    // 画像から数独を読み込むメソッド
    func loadSudoku() {
        // 枠内の画像を取得
        let imageInsideFrame = getImageInsideFrame()
        // ImagePreprocessorのインスタンスを生成
        let preprocessor = ImagePreprocessor(image: imageInsideFrame)
        // 画像の前処理を実行
        images = preprocessor.preprocess()
    } // loadSudoku ここまで

    // 枠内の画像を取得するメソッド
    private func getImageInsideFrame() -> UIImage {
        // アプリケーションの最初のシーンを取得し、それがUIWindowSceneであることを確認
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return UIImage() }
        // 取得したウィンドウシーンから、最初のウィンドウを取得
        guard let mainWindow = windowScene.windows.first else { return UIImage() }
        // ウィンドウのルートビューコントローラーのビューから、指定された枠内の画像を取得
        guard let image = mainWindow.rootViewController?.view.getImage(rect: frameRect) else { return UIImage() }
        // 取得した画像を保持
        return image
    } // getImageInsideFrame ここまで
} // ScanSudokuViewModel ここまで
