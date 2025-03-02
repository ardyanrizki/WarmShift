// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI

struct ImageSelectionSceneView: View {
    @State private var image: UIImage?
    
    @State private var yOffset: CGFloat = 0
    @State private var showImagePicker = false
    
    @EnvironmentObject private var navigationManager: NavigationManager<AppRoute>
    
    private let pullTreshold: CGFloat = 80
    
    enum ImageSelectionText {
        static let textDefault = "Select image first"
        static let textPulling = "Almost there!"
        static let subtext = "Simply pull to add an image from your library"
    }
    
    enum ImageSelectionIcon {
        static let iconDefault = "photo.badge.plus.fill"
        static let iconPulling = "arrow.down"
    }
    
    
    private let scrollViewNamespace = "ScrollView"
    
    private func pullRefreshProgress() -> Float {
        return Float(abs(max(yOffset, 0) / -pullTreshold))
    }
    
    private func isPulling() -> Bool {
        pullRefreshProgress() > 0
    }
    
    private func isPullTresholdReached() -> Bool {
        yOffset >= pullTreshold
    }
    
    private func maxHeight() -> CGFloat {
        UIScreen.main.bounds.height
    }
    
    var body: some View {
        VStack {
            ZStack {
                PullToAddView(progress: pullRefreshProgress(), offset: yOffset, treshold: pullTreshold)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        Button {
                            
                        } label: {
                            VStack(spacing: 24) {
                                Image(systemName: isPulling() ? ImageSelectionIcon.iconPulling : ImageSelectionIcon.iconDefault)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 80)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.accent, .secondary.opacity(0.5))
                                    .contentTransition(.symbolEffect(.replace))
                                
                                VStack(spacing: 8) {
                                    Text(isPulling() ? ImageSelectionText.textPulling : ImageSelectionText.textDefault)
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        .contentTransition(.identity)
                                    
                                    Text(ImageSelectionText.subtext)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)
                                }
                            }
                        }
                        .buttonStyle(SpringButtonStyle(action: { showImagePicker = true }))
                    }
                    .frame(width: UIScreen.main.bounds.width, height: maxHeight())
                    .padding(.horizontal, 16)
                    .background( GeometryReader { proxy in
                        self.detectScrollOffset(geometry: proxy)
                    })
                }
                .ignoresSafeArea()
                .coordinateSpace(name: scrollViewNamespace)
            }
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePickerView(image: $image)
        }
        .onChange(of: image, { _, image in
            if let image {
                navigationManager.navigate(to: .imageEditing(image))
            }
        })
        .sensoryFeedback(.impact(flexibility: .solid), trigger: isPullTresholdReached()) { _, newVal in
            newVal
        }
    }
    
    private func detectScrollOffset(geometry: GeometryProxy) -> some View {
        let newYOffset = geometry.frame(in: .named(scrollViewNamespace)).minY
        
        if yOffset != newYOffset {
            Task { @MainActor in
                self.yOffset = newYOffset
                
                if isPullTresholdReached() {
                    // Create a small delay if needed
                    try? await Task.sleep(nanoseconds: 200_000_000)
                    showImagePicker = true
                }
            }
        }
        
        return Rectangle().fill(Color.clear)
    }
}
