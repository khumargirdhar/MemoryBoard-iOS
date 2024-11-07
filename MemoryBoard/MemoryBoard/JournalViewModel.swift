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

    func deleteEntry(_ entry: JournalEntry) {
        entries.removeAll { $0.id == entry.id }
        dataManager.saveEntries(entries)
    }
    
    // Filter entries based on the search text matching title, content, or tags
    func filteredEntries(searchText: String) -> [JournalEntry] {
        if searchText.isEmpty {
            return entries
        }
        
        return entries.filter { entry in
            entry.title.localizedCaseInsensitiveContains(searchText) ||
            entry.content.localizedCaseInsensitiveContains(searchText) ||
            entry.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
        }
    }
}
