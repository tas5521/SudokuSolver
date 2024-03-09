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
} // ScanSudokuViewModel ここまで
