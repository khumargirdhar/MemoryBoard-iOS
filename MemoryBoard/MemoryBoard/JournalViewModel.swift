import SwiftUI

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = [] {
        didSet {
            saveEntries()
        }
    }

    private let entriesKey = "journalEntries"

    init() {
        loadEntries()
    }

    func addEntry(_ entry: JournalEntry) {
        DispatchQueue.main.async {
            self.entries.append(entry)
        }
    }

    private func saveEntries() {
        // Encode the entries array to JSON and save it
        if let encodedData = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encodedData, forKey: entriesKey)
        }
    }

    private func loadEntries() {
        // Load entries from UserDefaults
        if let savedData = UserDefaults.standard.data(forKey: entriesKey),
           let decodedEntries = try? JSONDecoder().decode([JournalEntry].self, from: savedData) {
            DispatchQueue.main.async {
                self.entries = decodedEntries
            }
        }
    }
}
