// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI
//import UIKit
import Combine
import CoreHaptics

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
            if let processedImage = processedImage {
                Image(uiImage: processedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Text("Choose image from Photos")
            }
            
            Text("\(Int(temperature * 100))%")
            
            Slider(value: $temperature, in: range, step: 0.04)
                .onChange(of: temperature) { _, newValue in
                    temperatureSubject.send(newValue)
                }
            
            
            Button("Choose") {
                showImagePicker = true
            }
            .padding()
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
        guard let image = image else { return }
        
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
