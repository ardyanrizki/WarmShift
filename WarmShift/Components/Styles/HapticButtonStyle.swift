// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI

struct HapticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .sensoryFeedback(.impact(flexibility: .solid), trigger: configuration.isPressed) { oldVal, newVal in
                oldVal && !newVal
            }
    }
}
