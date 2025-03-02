// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI

@MainActor
final class NavigationManager<Route: Hashable>: ObservableObject {
    @Published var path = NavigationPath()
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func navigate(to route: Route) {
        path.append(route)
    }
}
