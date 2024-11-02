//
//  EntryListView.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 26/09/24.
//

import SwiftUI

struct EntryListView: View {
    @State private var showNewEntryView = false
    @StateObject private var viewModel = JournalViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.entries.sorted(by: { $0.date > $1.date })) { entry in
                    NavigationLink(destination: EntryDetailView(entry: entry)) {
                        VStack(alignment: .leading) {
                            Text(entry.title)
                                .font(.headline)
                            Text(entry.date, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteEntries) // Add delete functionality here
            }
            .navigationTitle("MemoryBoard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showNewEntryView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showNewEntryView) {
                NewEntryView(viewModel: JournalViewModel())
            }
        }
    }
    
    func deleteEntries(at offsets: IndexSet) {
        viewModel.entries.remove(atOffsets: offsets)
    }
}

