import SwiftUI

struct EntryListView: View {
    @State private var showNewEntryView = false
    @ObservedObject private var viewModel = JournalViewModel()
    @State private var isEditing = false  // New State to toggle edit mode

    let columns = [
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.entries.sorted(by: { $0.date > $1.date })) { entry in
                        ZStack(alignment: .topTrailing) {
                            NavigationLink(destination: EntryDetailView(entry: entry)) {
                                JournalCardView(entry: entry)
                            }
                            .buttonStyle(PlainButtonStyle())

                            // Show a delete button in edit mode
                            if isEditing {
                                Button(action: {
                                    deleteEntry(entry)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                        .padding(5)
                                }
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteEntry(entry)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding()
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
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
            }
            .sheet(isPresented: $showNewEntryView) {
                NewEntryView(viewModel: viewModel)
            }
        }
    }
    
    // Helper function to delete an entry
    func deleteEntry(_ entry: JournalEntry) {
        if let index = viewModel.entries.firstIndex(where: { $0.id == entry.id }) {
            viewModel.entries.remove(at: index)
        }
    }
}

struct JournalCardView: View {
    let entry: JournalEntry

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let imageData = entry.images?.first, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
            }
            
            // Gradient overlay for text readability
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black.opacity(0)]),
                startPoint: .bottom,
                endPoint: .center
            )
            .frame(height: 80)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
