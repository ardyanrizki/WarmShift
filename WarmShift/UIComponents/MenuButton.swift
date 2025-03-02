// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI

struct MenuButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    let isDisabled: Bool
    
    var body: some View {
        Button {
            action()
        } label: {
            Label(title, systemImage: icon)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .labelStyle(.iconOnly)
                .foregroundColor(.secondary.opacity(isDisabled ? 0.3 : 1))
                .padding(.horizontal, 12)
                .frame(minWidth: 40)
                .frame(height: 40)
        }
        .buttonStyle(HapticButtonStyle())
        .disabled(isDisabled)
    }
}
