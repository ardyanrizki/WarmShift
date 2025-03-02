// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI

struct SpringButtonStyle: ButtonStyle {
    var action: () -> Void
    
    @State private var isInvalidateAction: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.bouncy, value: configuration.isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 10)
                    .onChanged({ _ in
                        isInvalidateAction = true
                    })
            )
            .highPriorityGesture(TapGesture())
            .onChange(of: configuration.isPressed) { wasPressed, isPressed in
                if wasPressed && !isPressed && !isInvalidateAction {
                    Task {
                        try? await Task.sleep(for: .milliseconds(200))
                        
                        await MainActor.run {
                            action()
                        }
                    }
                } else {
                    isInvalidateAction = false
                }
            }
            .sensoryFeedback(.impact(flexibility: .solid), trigger: configuration.isPressed) { oldVal, newVal in
                oldVal && !newVal && !isInvalidateAction
            }
    }
}
