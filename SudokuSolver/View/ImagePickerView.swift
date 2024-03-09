//
//  ImagePickerView.swift
//  SudokuSolver
//
//  Created by 寒河江彪流 on 2024/03/10.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    // 画面を閉じるための環境変数
    @Environment(\.dismiss) private var dismiss
    // ScanSudokuViewModelをバインディングで取得
    @Binding var viewModel: ScanSudokuViewModel
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        } // init ここまで
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.viewModel.image = originalImage
            } // if let ここまで
            parent.dismiss()
        } // imagePickerController ここまで
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        } // imagePickerControllerDidCancel ここまで
    } // Coordinator ここまで
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    } // makeCoordinator ここまで
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = context.coordinator
        return imagePickerController
    } // makeUIViewController ここまで
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    } // updateUIViewController ここまで
} // ImagePickerView ここまで
