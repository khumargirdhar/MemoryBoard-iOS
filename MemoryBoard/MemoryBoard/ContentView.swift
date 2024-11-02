//
//  ContentView.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 26/09/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = JournalViewModel()
    
    var body: some View {
        EntryListView()
//            .onAppear(perform: loadEntries) // Load entries when the app starts
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


