//
//  ContentView.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 26/09/24.
//

import SwiftUI

struct ContentView: View {
    @State private var entries: [JournalEntry] = [] {
        didSet {
            saveEntries() // Save entries whenever they change
        }
    }
    
    var body: some View {
        EntryListView(entries: $entries)
            .onAppear(perform: loadEntries) // Load entries when the app starts
    }

    // MARK: - FileManager Helper Methods
    
    // Get the URL for the documents directory where we will store the JSON file
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Save entries to disk as JSON
    func saveEntries() {
        let url = getDocumentsDirectory().appendingPathComponent("entries.json")
        
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: url)
        } catch {
            print("Failed to save entries: \(error.localizedDescription)")
        }
    }
    
    // Load entries from disk
    func loadEntries() {
        let url = getDocumentsDirectory().appendingPathComponent("entries.json")
        
        do {
            let data = try Data(contentsOf: url)
            entries = try JSONDecoder().decode([JournalEntry].self, from: data)
        } catch {
            print("No entries found or failed to load entries: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


