// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI

struct SpringButtonStyle: ButtonStyle {
    var action: () -> Void
    
    @State private var isInvalidateAction: Bool = false
    @State private var isPressing: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(isPressing ? 0.9 : 1.0)
            .animation(.bouncy, value: isPressing)
            .simultaneousGesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { _ in
                        isInvalidateAction = true
                    }
            )
            .onChange(of: configuration.isPressed) { wasPressed, isPressed in
                if isPressed {
                    isPressing = true
                } else if wasPressed && !isPressed {
                    Task {
                        try? await Task.sleep(for: .milliseconds(100)) // Efek tetap terlihat sebentar
                        await MainActor.run {
                            isPressing = false
                        }
                    }
                    
                    if !isInvalidateAction {
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
            }
            .sensoryFeedback(.impact(flexibility: .solid), trigger: configuration.isPressed) { oldVal, newVal in
                oldVal && !newVal && !isInvalidateAction
            }
    }
}
