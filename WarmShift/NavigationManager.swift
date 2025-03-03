// © 2025 Ardyan - Pattern Matters. All rights reserved.

import SwiftUI
import NavigationTransitions

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

public struct SlideTop: NavigationTransitionProtocol {

    public var body: some NavigationTransitionProtocol {
        MirrorPush {
            OnInsertion {
                Move(edge: .top)
            }
            OnRemoval {
                Move(edge: .bottom)
            }
        }
    }
}

extension AnyNavigationTransition {
    public static func slideTop() -> Self {
        .init(SlideTop())
    }
}
