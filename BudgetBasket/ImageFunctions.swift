//
//  ImageFunctions.swift
//  BudgetBasket
//
//  Created by Delaney Fisher on 11/25/24.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor class ImageFunctions: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var selectedImage: UIImage? = nil
    @Published var photoPickerSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: photoPickerSelection)
            errorMessage = nil
        }
    }
    
    // This function was created largely following the below video
    // https://www.youtube.com/watch?v=IZEYVX4vTOA&t=538s
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        errorMessage = nil
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    if let compressedImageString = compressImage(image: uiImage), compressedImageString != "n/a" {
                        selectedImage = uiImage
                    } else {
                        errorMessage = "Image too large"
                        selectedImage = nil
                    }
                
                }
            }
        }
    }
    
    func compressImage(image: UIImage) -> String? {
        let compression: CGFloat = 0.5
        // Firebase max size for data
        let maxSize: Int = 1048487
        let compressedData = image.jpegData(compressionQuality: compression)
        if let compressedData = compressedData, compressedData.count <= maxSize {
            return compressedData.base64EncodedString()
        } else {
            return "n/a"
        }
    }
}
