// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI

struct HapticButtonStyle: ButtonStyle {
    let isCancellation: Bool
    
    init(isCancellation: Bool = false) {
        self.isCancellation = isCancellation
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .sensoryFeedback(isCancellation ? .impact(flexibility: .soft) : .impact(flexibility: .solid), trigger: configuration.isPressed) { oldVal, newVal in
                oldVal && !newVal
            }
    }
}
