//
//  Route.swift
//  Learnify
//
//  Push-navigation destinations reachable from MainPage's NavigationStack.
//

import Foundation

enum LearningScope: Hashable {
    case language(id: Int64, name: String)
    case mega
}

enum Route: Hashable {
    case addLanguage
    case editLanguage(languageId: Int64, languageName: String)
    case addCard(languageId: Int64, languageName: String)
    case learning(LearningScope)
    case settings
}
