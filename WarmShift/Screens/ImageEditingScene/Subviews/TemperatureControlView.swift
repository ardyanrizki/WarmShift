// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI
import Combine
import CompactSlider

extension ImageEditingSceneView {
    struct TemperatureControlView: View {
        @Binding var temperature: Float
        let range: ClosedRange<Float>
        let temperatureSubject: PassthroughSubject<Float, Never>
        
        var body: some View {
            VStack(spacing: 16) {
                ProgressView(progress: temperature)
                    .frame(width: 48, height: 48)
                
                CompactSlider(value: $temperature, in: range, step: 0.04)
                    .compactSliderBackground(backgroundView: { _, _ in Color.clear })
                    .compactSliderStyle(default: .scrollable())
                    .compactSliderOptionsByAdding(.withoutBackground, .enabledHapticFeedback, .snapToSteps)
                    .frame(height: 44)
                    .padding(.bottom, 8)
                    .onChange(of: temperature) { _, newValue in
                        temperatureSubject.send(newValue)
                    }
                
                HStack(spacing: 8) {
                    Image(systemName: "thermometer.medium")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Text("Warmth")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundStyle(.primary)
                }
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}
