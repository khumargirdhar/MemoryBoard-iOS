import Foundation
import CoreData

extension JournalEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<JournalEntry> {
        return NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var tags: [String]?
    @NSManaged public var imagePaths: [String]?
    @NSManaged public var createdAt: Date?
    @NSManaged public var modifiedAt: Date?
}

extension JournalEntry: Identifiable {}

extension JournalEntry {
    var tagsArray: [String] {
        get {
            return tags ?? []
        }
        set {
            tags = newValue
        }
    }
    
    var imagePathsArray: [String] {
        get {
            return imagePaths ?? []
        }
        set {
            imagePaths = newValue
        }
    }
}
