import SwiftUI

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = [] {
        didSet {
            saveEntries()
        }
    }

    init() {
        loadEntries()
    }

    private let entriesKey = "journalEntries"

    func addEntry(_ entry: JournalEntry) {
        entries.append(entry)
    }

    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: entriesKey)
        }
    }

    private func loadEntries() {
        if let savedEntries = UserDefaults.standard.data(forKey: entriesKey),
           let decodedEntries = try? JSONDecoder().decode([JournalEntry].self, from: savedEntries) {
            entries = decodedEntries
        }
    }
}
