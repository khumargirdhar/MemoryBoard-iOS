//
//  DataManager.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 05/11/24.
//

import Foundation
import UIKit

class DataManager {
    private let entriesKey = "journalEntries"
    private let fileManager = FileManager.default
    private let imagesDirectory: URL
    
    init() {
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        imagesDirectory = urls[0].appendingPathComponent("JournalImages")
        
        if !fileManager.fileExists(atPath: imagesDirectory.path) {
            try? fileManager.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)
        }
    }
    
    func saveEntries(_ entries: [JournalEntry]) {
        if let encodedData = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encodedData, forKey: entriesKey)
        }
    }
    
    func loadEntries() -> [JournalEntry] {
        guard let data = UserDefaults.standard.data(forKey: entriesKey),
              let entries = try? JSONDecoder().decode([JournalEntry].self, from: data) else {
            return []
        }
        return entries
    }
    
    func saveImage(_ image: UIImage, for entryId: UUID) -> String? {
        let fileName = "\(entryId.uuidString).jpg"
        let fileURL = imagesDirectory.appendingPathComponent(fileName)

        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: fileURL)
            return fileName
        }
        return nil
    }
    
    func loadImage(named imageName: String) -> UIImage? {
        let fileURL = imagesDirectory.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: fileURL.path)
    }
}
