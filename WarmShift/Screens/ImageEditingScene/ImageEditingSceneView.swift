// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI
import Combine

struct ImageEditingSceneView: View {
    @Binding private var image: UIImage?
    @Binding private var isLoading: Bool
    
    @State private var processedImage: UIImage? = nil
    @State private var showShareSheet = false
    @State private var saveSuccess = false
    @State private var showError = false
    @State private var temperature: Float = 0.0
    @State private var isFurtherActionDisabled: Bool = true
    
    let range: ClosedRange<Float> = -1.0...1.0
    
    private var temperatureSubject = PassthroughSubject<Float, Never>()
    @State private var cancellable: AnyCancellable?
    
    init(image: Binding<UIImage?>, isLoading: Binding<Bool>) {
        self._image = image
        self._processedImage = .init(initialValue: image.wrappedValue)
        self._isLoading = isLoading
    }
    
    var body: some View {
        VStack {
            HStack {
                MenuButton(title: "Cancel", icon: "xmark", action: cancel, isDisabled: false)
                Spacer()
                MenuButton(title: "Save", icon: "square.and.arrow.down", action: saveImageToPhotos, isDisabled: isFurtherActionDisabled)
                MenuButton(title: "Share", icon: "square.and.arrow.up", action: {
                    showShareSheet = true
                }, isDisabled: isFurtherActionDisabled)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            Spacer()
            
            if let processedImage {
                ResizableImageView(image: processedImage)
            }
            
            Spacer()
            
            TemperatureControlView(temperature: $temperature, range: -1.0...1.0, temperatureSubject: temperatureSubject)
        }
        .onAppear {
            isLoading = false
            setupDebounce()
            temperature = 0.0
        }
        .onChange(of: temperature, { _, newValue in
            withAnimation(.bouncy) {
                isFurtherActionDisabled = newValue == 0
            }
        })
        .sheet(isPresented: $showShareSheet) {
            if let imageToShare = processedImage {
                ShareSheetView(activityItems: [imageToShare])
            }
        }
        .alert("Saved!", isPresented: $saveSuccess) {
            Button("OK", role: .cancel) {}
        }
        .alert("Failed to Save", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        }
    }
    
    private func cancel() {
        image = nil
        processedImage = nil
    }
    
    private func setupDebounce() {
        cancellable = temperatureSubject
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
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
    
    private func saveImageToPhotos() {
        guard let processedImage else { return }
        
        UIImageWriteToSavedPhotosAlbum(processedImage, nil, nil, nil)
        saveSuccess = true
    }
}
