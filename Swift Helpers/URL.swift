//
//  FileManager.swift
//  WeJourney
//
//  Created by Jean-Charles Mourey on 10/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

extension URL {
    func ensureExists() throws -> Self {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            try fileManager.createDirectory(at: self, withIntermediateDirectories: true, attributes: nil)
        }
        return self
    }
}
