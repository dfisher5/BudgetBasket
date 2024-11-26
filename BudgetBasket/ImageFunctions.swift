//
//  ImageFunctions.swift
//  BudgetBasket
//
//  Created by Delaney Fisher on 11/25/24.
//

import Foundation
import SwiftUI
import PhotosUI

class ImageFunctions: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var photoPickerSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: photoPickerSelection)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    return
                }
            }
        }
    }
    
    func compressImage(image: UIImage) -> String? {
        var compression: CGFloat = 1.0
        let maxSize: Int = 1048487
        var compressedData = image.jpegData(compressionQuality: compression)
        
        while let data = compressedData, data.count > maxSize && compression > 0 {
            compression -= 0.1
            compressedData = image.jpegData(compressionQuality: compression)
            print("image size: \(data.count)")
        }
        
        if let compressedData = compressedData, compressedData.count <= maxSize {
            return compressedData.base64EncodedString()
        } else {
            return "n/a"
        }
    }
}
