//
//  MemoryBoardApp.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 26/09/24.
//

import SwiftUI
import CoreData

@main
struct MemoryBoardApp: App {
    @StateObject private var dataController = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            EntryListView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}


