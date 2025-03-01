// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI

struct SpringButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.bouncy, value: configuration.isPressed)
            .sensoryFeedback(.impact(flexibility: .solid), trigger: configuration.isPressed) { oldVal, newVal in
                oldVal && !newVal
            }
    }
}
