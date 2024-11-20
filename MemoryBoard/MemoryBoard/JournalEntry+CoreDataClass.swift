//
//  JournalEntry+CoreDataClass.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 05/11/24.
//
//

import Foundation
import CoreData

@objc(JournalEntry)
public class JournalEntry: NSManagedObject {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        createdAt = Date()
        modifiedAt = Date()
    }
}
