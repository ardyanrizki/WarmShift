// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI

extension ImageSelectionSceneView {
    struct PullProgressView: View {
        var progress: Float
        
        private var strokeColor: Color {
            Color.green
        }
        
        private var backgroundColor: Color {
            strokeColor.opacity(0.2)
        }

        var body: some View {
            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height)
                let lineWidth: CGFloat = 5
                
                ZStack {
                    Circle()
                        .stroke(backgroundColor, lineWidth: lineWidth)
                    
                    Circle()
                        .trim(from: 0.0, to: abs(CGFloat(progress)))
                        .stroke(strokeColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: size, height: size)
            }
        }
    }
}
