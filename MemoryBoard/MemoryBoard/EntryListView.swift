import SwiftUI
import CoreData

struct EntryListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showNewEntryView = false
    @State private var isEditing = false
    @State private var showCalendarView = false
    @State private var searchText = ""
    @State private var showReminderSettings = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \JournalEntry.date, ascending: false)],
        animation: .default)
    private var entries: FetchedResults<JournalEntry>
    
    private let columns = [GridItem(.flexible())]
    
    var filteredEntries: [JournalEntry] {
        if searchText.isEmpty {
            return Array(entries)
        }
        return entries.filter { entry in
            (entry.title ?? "").localizedCaseInsensitiveContains(searchText) ||
            (entry.content ?? "").localizedCaseInsensitiveContains(searchText) ||
            (entry.tags ?? []).contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredEntries, id: \.self) { entry in
                        ZStack(alignment: .topTrailing) {
                            NavigationLink(destination: EntryDetailView(entry: entry)) {
                                JournalCardView(entry: entry)
                                    .contextMenu {
                                        Button(action: {
                                            // Handle edit
                                        }) {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        
                                        Button(role: .destructive, action: {
                                            deleteEntry(entry)
                                        }) {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            if isEditing {
                                Button(action: {
                                    withAnimation {
                                        deleteEntry(entry)
                                    }
                                }) {
                                    Image(systemName: "trash.circle.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.white, .red)
                                        .padding(5)
                                        .font(.title)
                                }
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                withAnimation {
                                    deleteEntry(entry)
                                }
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
                    Menu {
                        Button(action: { showNewEntryView = true }) {
                            Label("New Entry", systemImage: "square.and.pencil")
                        }
                        
                        Button(action: { showReminderSettings = true }) {
                            Label("Set Reminder", systemImage: "bell")
                        }
                        
                        Button(action: { showCalendarView = true }) {
                            Label("Calendar", systemImage: "calendar")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showNewEntryView = true }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { isEditing.toggle() }) {
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .sheet(isPresented: $showNewEntryView) {
                NewEntryView()
                    .environment(\.managedObjectContext, viewContext)
            }
            .sheet(isPresented: $showCalendarView) {
                CalendarView(entries: Array(entries))
                    .environment(\.managedObjectContext, viewContext)
            }
            .sheet(isPresented: $showReminderSettings) {
                ReminderSettingsView()
            }
        }
    }
    
    private func deleteEntry(_ entry: JournalEntry) {
        viewContext.delete(entry)
        
        // Delete associated images
        if let imagePaths = entry.imagePaths {
            for imagePath in imagePaths {
                try? FileManager.default.removeItem(atPath: imagePath)
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error deleting entry: \(error)")
        }
    }
}

struct JournalCardView: View {
    let entry: JournalEntry

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let firstImagePath = entry.imagePaths?.first,
               let uiImage = UIImage(contentsOfFile: firstImagePath) {
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
                Text(entry.title ?? "")
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(entry.date ?? Date(), style: .date)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}


