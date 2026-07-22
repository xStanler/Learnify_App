//
//  Router.swift
//  Learnify
//
//  Shared navigation path so any screen pushed onto MainPage's NavigationStack
//  can push further (e.g. Edit Language -> Add Card) without threading a
//  Binding<NavigationPath> through every view.
//

import SwiftUI

final class Router: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
