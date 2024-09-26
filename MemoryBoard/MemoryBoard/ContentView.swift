//
//  ContentView.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 26/09/24.
//

import SwiftUI

struct ContentView: View {
    @State private var entries: [JournalEntry] = [] // State to store journal entries
    
    var body: some View {
        EntryListView(entries: $entries) // Pass the entries as a Binding to EntryListView
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

