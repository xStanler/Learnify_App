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
            let dbURL = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
                .first!
            
            print(dbURL)

            let db = try Connection("\(dbURL)/languages.sqlite")
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
            t.column(Schema.word, unique: true)
            t.column(Schema.translation, unique: true)
            t.column(Schema.help_image)
            t.column(Schema.proficiency_level, defaultValue: 0)
            
            t.column(Schema.language_id_fk)
            t.foreignKey(Schema.language_id_fk,
                         references: Schema.languages, Schema.language_id,
                         update: .cascade,
                         delete: .cascade
            )
        })
    }
}

extension Database {
    struct LanguageRow {
        let id: Int64
        let name: String
        let numberOfLessons: Int64
    }
    
    static func fetchLanguages() throws -> [LanguageRow] {
        let db = connection
        var result: [LanguageRow] = []
        
        for row in try db.prepare(Schema.languages) {
            let id = row[Schema.language_id]
            let name = row[Schema.language_name]
            let numberOfLessons = row[Schema.language_id]
            
            result.append(LanguageRow(id: id, name: name, numberOfLessons: numberOfLessons))
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
}
