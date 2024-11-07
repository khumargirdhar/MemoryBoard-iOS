import SwiftUI

struct EntryListView: View {
    @State private var showNewEntryView = false
    @ObservedObject private var viewModel = JournalViewModel()
    @State private var isEditing = false
    @State private var showCalendarView = false
    @State private var searchText = ""  // State variable for search text
    
    let columns = [GridItem(.flexible())]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.filteredEntries(searchText: searchText).sorted(by: { $0.date > $1.date })) { entry in
                        ZStack(alignment: .topTrailing) {
                            NavigationLink(destination: EntryDetailView(entry: entry)) {
                                JournalCardView(entry: entry)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            if isEditing {
                                Button(action: {
                                    deleteEntry(entry)
                                }) {
                                    Image(systemName: "trash.circle.fill")
                                        .foregroundColor(.red)
                                        .padding(5)
                                        .font(.title)
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
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showCalendarView = true
                    }) {
                        Image(systemName: "calendar")
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .sheet(isPresented: $showNewEntryView) {
                NewEntryView(viewModel: viewModel)
            }
            .sheet(isPresented: $showCalendarView) {
                CalendarView(entries: viewModel.entries, onSelectDate: { date in })
            }
        }
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        viewModel.deleteEntry(entry)
    }
}

struct JournalCardView: View {
    let entry: JournalEntry

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            if let firstImagePath = entry.images.first, let uiImage = UIImage(contentsOfFile: firstImagePath) {
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


