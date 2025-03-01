// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI
import Combine
import CoreHaptics
import CompactSlider

struct ContentView: View {
    @State private var image: UIImage? = nil
    @State private var isLoading = false
    
    @State private var activeScene: Scene = .imageSelection
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                
            } else {
                switch activeScene {
                case .imageSelection:
                    ImageSelectionSceneView(image: $image, isLoading: $isLoading)
                    
                case .imageEditing:
                    ImageEditingSceneView(image: $image, isLoading: $isLoading)
                }
                
            }
        }
        .onChange(of: image) { _, newValue in
            activeScene = newValue == nil ? .imageSelection : .imageEditing
        }
    }
    
    enum Scene {
        case imageSelection
        case imageEditing
    }
}

#Preview {
    ContentView()
}
