// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI

extension ImageEditingSceneView {
    struct ProgressView: View {
        var progress: Float
        
        private var strokeColor: Color {
            progress == 0 ? Color.primary : progress >= 0 ? Color.orange : Color.blue
        }
        
        private var backgroundColor: Color {
            strokeColor.opacity(0.2)
        }
        
        var body: some View {
            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height)
                let lineWidth: CGFloat = 2
                
                ZStack {
                    Circle()
                        .stroke(backgroundColor, lineWidth: lineWidth)
                    
                    Circle()
                        .trim(from: 0.0, to: abs(CGFloat(progress)) / 1.0) // Pakai abs() supaya tetap positif
                        .stroke(strokeColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .rotationEffect(.degrees(progress >= 0 ? -90 : 90))
                        .scaleEffect(x: 1.0, y: progress >= 0 ? 1.0 : -1.0)
                    
                    Text("\(Int(round(progress * 100)))")
                        .font(.system(size: size * 0.3))
                        .foregroundColor(strokeColor)
                }
                .frame(width: size, height: size)
            }
        }
    }
}
