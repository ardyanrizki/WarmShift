// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI
import Combine

struct ImageEditingSceneView: View {
    @State private var image: UIImage
    @State private var processedImage: UIImage? = nil
    @State private var showShareSheet = false
    @State private var saveSuccess = false
    @State private var showError = false
    @State private var temperature: Float = 0.0
    @State private var isFurtherActionDisabled: Bool = true
    
    let range: ClosedRange<Float> = -1.0...1.0
    
    private var temperatureSubject = PassthroughSubject<Float, Never>()
    @State private var cancellable: AnyCancellable?
    
    @EnvironmentObject private var navigationManager: NavigationManager<AppRoute>
    
    init(image: UIImage) {
        self.image = image
    }
    
    enum ImageEditingText {
        static let cancel = "Cancel"
        static let save = "Save"
        static let share = "Share"
        static let savedSuccess = "Saved!"
        static let savedFailure = "Failed to Save"
        static let ok = "OK"
    }
    
    enum ImageEditingIcon {
        static let cancel = "xmark"
        static let save = "plus.square.on.square"
        static let share = "square.and.arrow.up"
    }
    
    var body: some View {
        VStack {
            HStack {
                MenuButton(title: ImageEditingText.cancel, icon: ImageEditingIcon.cancel, action: cancel, isDisabled: false)
                Spacer()
                MenuButton(title: ImageEditingText.save, icon: ImageEditingIcon.save, action: saveImageToPhotos, isDisabled: isFurtherActionDisabled)
                MenuButton(title: ImageEditingText.share, icon: ImageEditingIcon.share, action: {
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
        .navigationBarBackButtonHidden(true)
        .onAppear {
            temperature = 0.0
            processImage(with: temperature)
            setupDebounce()
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
        .alert(ImageEditingText.savedSuccess, isPresented: $saveSuccess) {
            Button(ImageEditingText.ok, role: .cancel) {}
        }
        .alert(ImageEditingText.savedFailure, isPresented: $showError) {
            Button(ImageEditingText.ok, role: .cancel) {}
        }
    }
    
    private func cancel() {
        processedImage = nil
        navigationManager.pop()
    }
    
    private func setupDebounce() {
        cancellable = temperatureSubject
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .sink { newValue in
                processImage(with: newValue)
            }
    }
    
    private func processImage(with temp: Float) {
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

