// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI
import Combine
import CoreHaptics
import CompactSlider

struct ContentView: View {
    @State private var image: UIImage? = nil
    @State private var processedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var temperature: Float = 0.0

    let range: ClosedRange<Float> = -1.0...1.0
    
    private var temperatureSubject = PassthroughSubject<Float, Never>()
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    processedImage = nil
                }, label: {
                    Label("Cancel", systemImage: "xmark.circle")
                        .foregroundColor(.black)
                        .padding(.horizontal, 12)
                        .frame(height: 40)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                })
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
            .padding(16)
            
            Spacer()
            
            if let processedImage {
                ResizableImageView(image: processedImage)
            } else {
                VStack {
                    Text("Choose image from Photos")
                    
                    Button("Choose") {
                        showImagePicker = true
                    }
                    .padding()
                }
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                CircularProgressView(progress: temperature)
                    .frame(width: 48, height: 48)
                
                CompactSlider(value: $temperature, in: range, step: 0.04)
                    .compactSliderBackground(backgroundView: { configuration, padding in
                        Color.clear
                    })
                    .compactSliderStyle(default: .scrollable())
                    .compactSliderOptionsByAdding(.withoutBackground, .enabledHapticFeedback, .snapToSteps)
                    .frame(height: 28)
                    .onChange(of: temperature) { _, newValue in
                        temperatureSubject.send(newValue)
                    }
                
                Label("Warmth", systemImage: "thermometer.medium")
                    .labelStyle(.titleAndIcon)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 12)
                    .frame(height: 40)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .onAppear {
            setupDebounce()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(image: $image, processedImage: $processedImage)
        }
    }
    
    private func setupDebounce() {
        cancellable = temperatureSubject
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main) // Tunggu 200ms sebelum update
            .sink { newValue in
                processImage(with: newValue)
            }
    }
    
    private func processImage(with temp: Float) {
        guard let image else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let processed = OpenCVWrapper.adjustTemperature(image, temperature: temp)
            
            DispatchQueue.main.async {
                processedImage = processed
            }
        }
    }
}

#Preview {
    ContentView()
}
