//
//  PhotoPickerView.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 26/09/24.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage] // Binding to store the selected images
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0 // Allow multiple image selection
        configuration.filter = .images // Only show images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPickerView
        
        init(_ parent: PhotoPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                        guard let self = self, let image = image as? UIImage else { return }
                        DispatchQueue.main.async {
                            self.parent.selectedImages.append(image)
                        }
                    }
                }
            }
        }
    }
}


struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
            PhotoPickerView(selectedImages: .constant(sampleImages)) // Providing sample images
    }

    // Sample images for the preview (using system icons)
    static var sampleImages: [UIImage] {
        return [
            UIImage(systemName: "photo")!,
            UIImage(systemName: "photo.fill")!
        ]
    }
}
