import CoreData
import SwiftUI

class JournalViewModel: ObservableObject {
    let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    func addEntry(_ title: String, content: String, date: Date, tags: [String], imagePaths: [String]) {
        let entry = JournalEntry(context: viewContext)
        entry.id = UUID()
        entry.title = title
        entry.content = content
        entry.date = date
        entry.tags = tags
        entry.imagePaths = imagePaths
        entry.createdAt = Date()
        entry.modifiedAt = Date()
        
        saveContext()
    }
    
    func updateEntry(_ entry: JournalEntry, title: String, content: String, date: Date, tags: [String]) {
        entry.title = title
        entry.content = content
        entry.date = date
        entry.tags = tags
        entry.modifiedAt = Date()
        
        saveContext()
    }
    
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
