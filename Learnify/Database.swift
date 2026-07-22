//
//  Database.swift
//  Learnify
//
//  Created by Stanisław Chmielewski on 23/12/2025.
//

import Foundation
import SQLite

enum Database {
    static let connection: Connection = {
        do {
            let appSupportURL = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )

            let db = try Connection("\(appSupportURL.path)/languages.sqlite")
            try migrate(on: db)
            return db
        } catch {
            fatalError("Failed to open or migrate database: \(error)")
        }
    }()

    // Define your schema types and expressions once.
    struct Schema {
        static let languages = Table("languages")
        static let language_id = Expression<Int64>("id")
        static let language_name = Expression<String>("language_name")
        static let number_of_lessons = Expression<Int64>("number_of_lessons")

        static let words = Table("words")
        static let word_id = Expression<Int64>("id")
        static let word = Expression<String>("word")
        static let translation = Expression<String>("translation")
        static let help_image = Expression<String?>("help_image")
        static let proficiency_level = Expression<Int64>("proficiency_level")
        static let language_id_fk = Expression<Int64>("language_id")
    }

    // Create tables / run migrations.
    private static func migrate(on db: Connection) throws {
        try db.run(Schema.languages.create(ifNotExists: true) { t in
            t.column(Schema.language_id, primaryKey: .autoincrement)
            t.column(Schema.language_name, unique: true)
            t.column(Schema.number_of_lessons, defaultValue: 0)
        })

        try db.run(Schema.words.create(ifNotExists: true) { t in
            t.column(Schema.word_id, primaryKey: .autoincrement)
            t.column(Schema.word)
            t.column(Schema.translation)
            t.column(Schema.help_image)
            t.column(Schema.proficiency_level, defaultValue: 0)

            t.column(Schema.language_id_fk)
            t.foreignKey(Schema.language_id_fk,
                         references: Schema.languages, Schema.language_id,
                         update: .cascade,
                         delete: .cascade
            )

            // A word only needs to be unique within its own language — the same
            // spelling can legitimately exist under two different languages, and
            // many words share a translation (e.g. several languages' words for
            // "cat" all translate to "cat"), so translation is intentionally not
            // constrained here.
            t.unique(Schema.language_id_fk, Schema.word)
        })
    }
}

extension Database {
    struct LanguageRow {
        let id: Int64
        let name: String
        //let numberOfLessons: Int64
    }

    static func fetchLanguages() throws -> [LanguageRow] {
        let db = connection
        var result: [LanguageRow] = []

        for row in try db.prepare(Schema.languages) {
            let id = row[Schema.language_id]
            let name = row[Schema.language_name]
            //let numberOfLessons = row[Schema.language_id]

            result.append(LanguageRow(id: id, name: name, /*numberOfLessons: numberOfLessons*/))
        }

        return result
    }
}

extension Database {
    @discardableResult
    static func insertLanguage(name: String, numberOfLessons: Int64 = 0) throws -> Int64 {
        let insert = Schema.languages.insert(
            Schema.language_name <- name,
            Schema.number_of_lessons <- numberOfLessons
        )

        return try connection.run(insert)
    }

    /// Deletes a language and all of its words. Removes the word rows explicitly
    /// rather than relying on the schema's cascade delete, since SQLite only
    /// enforces foreign keys when `PRAGMA foreign_keys` is turned on per
    /// connection — this stays correct regardless of that setting.
    static func deleteLanguage(id: Int64) throws {
        try connection.run(Schema.words.filter(Schema.language_id_fk == id).delete())
        try connection.run(Schema.languages.filter(Schema.language_id == id).delete())
    }
}

extension Database {
    struct WordRow: Identifiable {
        let id: Int64
        let word: String
        let translation: String
        let helpImage: String?
        let proficiencyLevel: Int64
        let languageId: Int64
    }

    static func fetchWords(languageId: Int64) throws -> [WordRow] {
        let db = connection
        var result: [WordRow] = []

        let query = Schema.words.filter(Schema.language_id_fk == languageId)
        for row in try db.prepare(query) {
            result.append(WordRow(
                id: row[Schema.word_id],
                word: row[Schema.word],
                translation: row[Schema.translation],
                helpImage: row[Schema.help_image],
                proficiencyLevel: row[Schema.proficiency_level],
                languageId: row[Schema.language_id_fk]
            ))
        }

        return result
    }

    /// All cards across every language — used by the "mega lesson" mode.
    static func fetchAllWords() throws -> [WordRow] {
        let db = connection
        var result: [WordRow] = []

        for row in try db.prepare(Schema.words) {
            result.append(WordRow(
                id: row[Schema.word_id],
                word: row[Schema.word],
                translation: row[Schema.translation],
                helpImage: row[Schema.help_image],
                proficiencyLevel: row[Schema.proficiency_level],
                languageId: row[Schema.language_id_fk]
            ))
        }

        return result
    }

    @discardableResult
    static func insertWord(word: String, translation: String, helpImage: String? = nil, languageId: Int64) throws -> Int64 {
        let insert = Schema.words.insert(
            Schema.word <- word,
            Schema.translation <- translation,
            Schema.help_image <- helpImage,
            Schema.language_id_fk <- languageId
        )

        return try connection.run(insert)
    }

    static func deleteWord(id: Int64) throws {
        let row = Schema.words.filter(Schema.word_id == id)
        try connection.run(row.delete())
    }

    /// Nudges a card's proficiency by `delta` (positive on a correct answer, negative
    /// on a wrong one), clamped at zero so repeated wrong answers can't go negative.
    static func updateProficiency(id: Int64, delta: Int64) throws {
        let row = Schema.words.filter(Schema.word_id == id)
        guard let current = try connection.pluck(row) else { return }
        let newValue = max(0, current[Schema.proficiency_level] + delta)
        try connection.run(row.update(Schema.proficiency_level <- newValue))
    }
}
