//
//  CardImport.swift
//  Learnify
//
//  Bulk card import from .md/.txt files ("word | translation" per line), and
//  the translation-matching rule used to grade answers during a learning session.
//

import Foundation

enum CardImport {
    struct ParsedCard {
        let word: String
        let translation: String
    }

    struct Result {
        let cards: [ParsedCard]
        let skippedLines: Int
    }

    /// Parses one `word | translation` pair per line. Blank lines and lines that
    /// don't split into exactly two non-empty parts are skipped and counted so the
    /// caller can tell the user "N lines could not be imported".
    static func parse(_ text: String) -> Result {
        var cards: [ParsedCard] = []
        var skipped = 0

        for rawLine in text.split(separator: "\n", omittingEmptySubsequences: false) {
            let line = rawLine.trimmingCharacters(in: .whitespaces)
            guard !line.isEmpty else { continue }

            let parts = line.components(separatedBy: "|")
            guard parts.count == 2 else {
                skipped += 1
                continue
            }

            let word = parts[0].trimmingCharacters(in: .whitespaces)
            let translation = parts[1].trimmingCharacters(in: .whitespaces)
            guard !word.isEmpty, !translation.isEmpty else {
                skipped += 1
                continue
            }

            cards.append(ParsedCard(word: word, translation: translation))
        }

        return Result(cards: cards, skippedLines: skipped)
    }
}

/// Case- and diacritic-insensitive translation check, e.g. "cafe"/"CAFE" both match "café".
func translationMatches(_ input: String, _ expected: String) -> Bool {
    func normalize(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .caseInsensitive, .widthInsensitive], locale: .current)
    }
    return normalize(input) == normalize(expected)
}
