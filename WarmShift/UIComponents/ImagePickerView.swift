// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isLoading: Bool
    let allowedExtensions: [String]
    
    init(image: Binding<UIImage?>, isLoading: Binding<Bool>, allowedExtensions: [String] = ["jpg", "jpeg"]) {
        self._image = image
        self._isLoading = isLoading
        self.allowedExtensions = allowedExtensions
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let result = results.first else {
                return
            }
            
            parent.isLoading = true

            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                guard let url = url, error == nil else {
                    return
                }

                let fileExtension = url.pathExtension.lowercased()

                if self.parent.allowedExtensions.contains(fileExtension) {
                    if let imageData = try? Data(contentsOf: url),
                       let uiImage = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.parent.image = uiImage
                            self.parent.isLoading = false
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.parent.isLoading = false
                        self.showFormatError()
                    }
                }
            }
        }
        
        private func showFormatError() {
            DispatchQueue.main.async {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootVC = scene.windows.first?.rootViewController {
                    let alert = UIAlertController(title: "Unsupported format", message: "Only JPEG images are allowed.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    rootVC.present(alert, animated: true)
                }
            }
        }
    }
}
