import Foundation

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    private let dataManager = DataManager()

    init() {
        // Load entries from the data manager when the view model is initialized
        self.entries = dataManager.loadEntries()
    }
    
    func addEntry(_ entry: JournalEntry) {
        // Add a new entry and save the updated entries array
        entries.append(entry)
        dataManager.saveEntries(entries)
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        // Remove the specified entry and save the updated entries array
        entries.removeAll { $0.id == entry.id }
        dataManager.saveEntries(entries)
    }
}
