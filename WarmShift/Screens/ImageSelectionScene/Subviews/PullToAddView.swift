// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI

extension ImageSelectionSceneView {
    struct PullToAddView: View {
        let progress: Float
        let offset: CGFloat
        let treshold: CGFloat
        
        func isCheckmarkActive() -> Bool {
            offset >= treshold
        }
        
        var body: some View {
            VStack(spacing: 16) {
                ZStack {
                    PullProgressView(progress: progress)
                    
                    Image(systemName: "checkmark")
                        .symbolEffect(.disappear, isActive: !isCheckmarkActive())
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.green)
                }
                .frame(width: 50, height: 50)
            }
            .scaleEffect(min(offset / 100, 0.8))
            .offset(y: -400 + offset)
            .padding(.bottom, 0 + offset / 2)
        }
    }
}
