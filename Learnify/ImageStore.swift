//
//  ImageStore.swift
//  Learnify
//
//  Saves card help-images to disk (Application Support, alongside the database,
//  so they survive the same way the DB does) and resolves filenames back to images.
//

import Foundation
import UIKit

enum ImageStore {
    private static let folderName = "CardImages"

    private static var folderURL: URL {
        get throws {
            let appSupportURL = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let folder = appSupportURL.appendingPathComponent(folderName, isDirectory: true)
            if !FileManager.default.fileExists(atPath: folder.path) {
                try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            }
            return folder
        }
    }

    /// Saves JPEG data under a new UUID filename and returns just the filename —
    /// that's what gets stored in `words.help_image`, not a full path.
    @discardableResult
    static func save(_ data: Data) throws -> String {
        let filename = "\(UUID().uuidString).jpg"
        let fileURL = try folderURL.appendingPathComponent(filename)
        try data.write(to: fileURL)
        return filename
    }

    static func loadImage(_ filename: String) -> UIImage? {
        guard let fileURL = try? folderURL.appendingPathComponent(filename) else { return nil }
        return UIImage(contentsOfFile: fileURL.path)
    }

    static func delete(_ filename: String) {
        guard let fileURL = try? folderURL.appendingPathComponent(filename) else { return }
        try? FileManager.default.removeItem(at: fileURL)
    }
}
