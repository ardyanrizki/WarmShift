// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI
import Combine
import NavigationTransitions

struct ContentView: View {
    @StateObject var navigationManager: NavigationManager<AppRoute>
    
    init() {
        self._navigationManager = StateObject(wrappedValue: NavigationManager<AppRoute>())
    }
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            ImageSelectionSceneView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .imageEditing(let image):
                        ImageEditingSceneView(image: image)
                    }
                }
        }
        .environmentObject(navigationManager)
        .navigationTransition(.slide(axis: .vertical))
    }
}

#Preview {
    ContentView()
}

enum AppRoute: Hashable {
    case imageEditing(UIImage)
}
