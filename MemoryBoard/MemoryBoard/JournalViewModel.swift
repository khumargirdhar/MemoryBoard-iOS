import Foundation

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    private let dataManager = DataManager()

    init() {
        self.entries = dataManager.loadEntries()
    }
    
    func addEntry(_ entry: JournalEntry) {
        entries.append(entry)
        dataManager.saveEntries(entries)
    }
}
