//
//  LearnifyTests.swift
//  LearnifyTests
//
//  Created by Stanisław Chmielewski on 17/10/2025.
//

import Foundation
import Testing
@testable import Learnify

struct LearnifyTests {

    @Test func wordCRUDRoundTrip() async throws {
        let languageId = try Database.insertLanguage(name: "Test-\(UUID().uuidString)")

        let wordId = try Database.insertWord(word: "house", translation: "casa", languageId: languageId)
        var words = try Database.fetchWords(languageId: languageId)
        #expect(words.count == 1)
        #expect(words.first?.word == "house")
        #expect(words.first?.translation == "casa")
        #expect(words.first?.proficiencyLevel == 0)

        try Database.updateProficiency(id: wordId, delta: 1)
        words = try Database.fetchWords(languageId: languageId)
        #expect(words.first?.proficiencyLevel == 1)

        // Proficiency is clamped at zero, never goes negative.
        try Database.updateProficiency(id: wordId, delta: -5)
        words = try Database.fetchWords(languageId: languageId)
        #expect(words.first?.proficiencyLevel == 0)

        try Database.deleteWord(id: wordId)
        words = try Database.fetchWords(languageId: languageId)
        #expect(words.isEmpty)
    }

    @Test func sameWordSpellingAllowedAcrossDifferentLanguages() async throws {
        let languageAId = try Database.insertLanguage(name: "Test-A-\(UUID().uuidString)")
        let languageBId = try Database.insertLanguage(name: "Test-B-\(UUID().uuidString)")

        // "chat" (French for cat) and "chat" (English word) should be able to coexist
        // as long as they belong to different languages.
        let wordAId = try Database.insertWord(word: "chat", translation: "cat", languageId: languageAId)
        let wordBId = try Database.insertWord(word: "chat", translation: "conversation", languageId: languageBId)

        #expect(try Database.fetchWords(languageId: languageAId).first?.translation == "cat")
        #expect(try Database.fetchWords(languageId: languageBId).first?.translation == "conversation")

        try Database.deleteWord(id: wordAId)
        try Database.deleteWord(id: wordBId)
    }

    @Test func translationMatchesIsCaseAndAccentInsensitive() async throws {
        #expect(translationMatches("cafe", "café"))
        #expect(translationMatches("CAFE", "café"))
        #expect(translationMatches("  café  ", "café"))
        #expect(!translationMatches("tea", "café"))
    }

    @Test func parseCardImportSkipsBlankAndMalformedLines() async throws {
        let text = """
        house | Haus
        this line has no pipe
        car|Auto

        | missing word
        train |
        """

        let result = CardImport.parse(text)

        #expect(result.cards.count == 2)
        #expect(result.cards[0].word == "house")
        #expect(result.cards[0].translation == "Haus")
        #expect(result.cards[1].word == "car")
        #expect(result.cards[1].translation == "Auto")
        #expect(result.skippedLines == 3)
    }

}
