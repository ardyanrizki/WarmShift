// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI

struct ImageSelectionSceneView: View {
    @Binding private var image: UIImage?
    @Binding private var isLoading: Bool
    
    @State private var yOffset: CGFloat = 0
    @State private var showImagePicker = false
    
    private let pullTreshold: CGFloat = 80
    
    func pullRefreshProgress() -> Float {
        return Float(abs(max(yOffset, 0) / -pullTreshold))
    }
    
    func isPulling() -> Bool {
        pullRefreshProgress() > 0
    }
    
    func isPullTresholdReached() -> Bool {
        yOffset >= pullTreshold
    }
    
    private func maxHeight() -> CGFloat {
        UIScreen.main.bounds.height
    }
    
    init(image: Binding<UIImage?>, isLoading: Binding<Bool>) {
        self._image = image
        self._isLoading = isLoading
    }
    
    var body: some View {
        ZStack {
            PullToAddView(progress: pullRefreshProgress(), offset: yOffset, treshold: pullTreshold)
            
            ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        Button {
                            showImagePicker = true
                        } label: {
                            VStack(spacing: 24) {
                                Image(systemName: isPulling() ? "arrow.down" : "photo.badge.plus.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 80)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.accent, .secondary.opacity(0.5))
                                    .contentTransition(.symbolEffect(.replace))
                                
                                VStack(spacing: 8) {
                                    Text(isPulling() ? "Almost there!" : "Select image first")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        .contentTransition(.identity)
                                    
                                    Text("Pull to add an image from your library")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)
                                }
                            }
                        }
                        .buttonStyle(SpringButtonStyle())

                    }
                    .frame(width: UIScreen.main.bounds.width, height: maxHeight())
                    .padding(.horizontal, 16)
                    .background( GeometryReader { proxy in
                        self.detectScrollOffset(geometry: proxy)
                    })
            }
            .ignoresSafeArea()
            .coordinateSpace(name: "ScrollView")
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePickerView(image: $image, isLoading: $isLoading)
        }
        .sensoryFeedback(.impact(flexibility: .solid), trigger: isPullTresholdReached()) { _, newVal in
            newVal
        }
    }
    
    private func detectScrollOffset(geometry: GeometryProxy) -> some View {
        let yOffset = geometry.frame(in: .named("ScrollView")).minY
        
        DispatchQueue.main.async {
            self.yOffset = yOffset
            if isPullTresholdReached() {
                Task {
                    try? await Task.sleep(nanoseconds: 200_000_000)
                    showImagePicker = true
                }
            }
        }
        return Rectangle().fill(Color.clear)
    }
}
