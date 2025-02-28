// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI

struct ResizableImageView: View {
    let image: UIImage

    var body: some View {
        GeometryReader { geometry in
            let imageSize = image.size
            let availableHeight = geometry.size.height // Tinggi yang tersedia
            let imageAspectRatio = imageSize.width / imageSize.height
            let calculatedWidth = availableHeight * imageAspectRatio
            
            Image(uiImage: image)
                .resizable()
                .scaledToFit() // Menyesuaikan lebar berdasarkan tinggi
                .frame(width: calculatedWidth, height: availableHeight)
                .clipped()
        }
    }
}
