//
//  MainPageViewModel.swift
//  Learnify
//
//  Created by Stanisław Chmielewski on 23/12/2025.
//

import Foundation

final class MainPageViewModel: ObservableObject {
    @Published var languages: [Database.LanguageRow] = []
    @Published var errorMessage: String?
    
    func load() {
        do {
            if languages.isEmpty {
                try Database.insertLanguage(name: "French")
                try Database.insertLanguage(name: "Polish")
            }
            languages = try Database.fetchLanguages()
            
        } catch {
            errorMessage = "Failed to load languages: \(error)"
        }
    }
}
