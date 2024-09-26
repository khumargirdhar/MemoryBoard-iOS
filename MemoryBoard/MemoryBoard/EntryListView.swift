//
//  EntryListView.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 26/09/24.
//

import SwiftUI

struct EntryListView: View {
    @Binding var entries: [JournalEntry] // Declare entries as Binding
    @State private var showNewEntryView = false
    
    var body: some View {
        NavigationView {
            List(entries.sorted(by: { $0.date > $1.date })) { entry in
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
            .navigationTitle("Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showNewEntryView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showNewEntryView) {
                NewEntryView(entries: $entries)
            }
        }
    }
}


struct EntryListView_Previews: PreviewProvider {
    static var previews: some View {
        EntryListView(entries: .constant([
            JournalEntry(
                title: "First Journal Entry",
                content: "Today was a great day!",
                date: Date(),
                tags: ["Personal", "Happy"],
                imageData: nil
            ),
            JournalEntry.example
        ]))
    }
}


