//
//  JounalEntry.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 26/09/24.
//

import Foundation

struct JournalEntry: Identifiable, Codable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
    var tags: [String]
    var imageData: Data? // for storing images
}

extension JournalEntry {
    static var example: JournalEntry {
        JournalEntry(
            title: "A Day at the Park",
            content: "Today I spent a lovely day at the park with friends. The weather was beautiful!",
            date: Date(),
            tags: ["Nature", "Friends", "Outdoors"],
            imageData: nil
        )
    }
}


