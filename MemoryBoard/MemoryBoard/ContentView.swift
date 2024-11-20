//
//  ContentView.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 26/09/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        EntryListView()
            .environment(\.managedObjectContext, viewContext)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
    }
}


