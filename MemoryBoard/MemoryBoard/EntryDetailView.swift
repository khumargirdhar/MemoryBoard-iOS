import SwiftUI
import CoreData

struct EntryDetailView: View {
    let entry: JournalEntry
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: JournalViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isEditing = false
    @State private var editedTitle: String = ""
    @State private var editedContent: String = ""
    @State private var editedTags: String = ""
    @State private var editedDate: Date = Date()
    
    init(entry: JournalEntry) {
        self.entry = entry
        _viewModel = StateObject(wrappedValue: JournalViewModel(context: CoreDataManager.shared.viewContext))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if !(entry.imagePathsArray.isEmpty) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(entry.imagePathsArray, id: \.self) { imagePath in
                                if let uiImage = UIImage(contentsOfFile: imagePath) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 350, height: 350)
                                        .cornerRadius(10)
                                        .clipped()
                                }
                            }
                        }
                    }
                    .frame(height: 350)
                    .padding(.bottom, 20)
                }
                
                if isEditing {
                    VStack(alignment: .leading, spacing: 16) {
                        TextField("Title", text: $editedTitle)
                            .font(.largeTitle)
                            .bold()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        DatePicker("Date", selection: $editedDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .padding(.vertical, 8)
                        
                        Text("Content")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        TextEditor(text: $editedContent)
                            .frame(minHeight: 200)
                            .padding(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        
                        Text("Tags")
                            .font(.headline)
                        
                        TextField("Tags (comma-separated)", text: $editedTags)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(entry.title ?? "")
                            .font(.largeTitle)
                            .bold()
                        
                        Text(formattedDate(entry.date ?? Date()))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(entry.content ?? "")
                            .font(.body)
                            .padding(.vertical, 8)
                        
                        if !entry.tagsArray.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(entry.tagsArray, id: \.self) { tag in
                                        Text(tag)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.blue.opacity(0.1))
                                            .foregroundColor(.blue)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if isEditing {
                        saveChanges()
                    }
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Save" : "Edit")
                        .bold()
                }
            }
            
            if isEditing {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isEditing = false
                        resetEditedValues()
                    }
                }
            }
        }
        .onAppear {
            resetEditedValues()
        }
    }
    
    private func resetEditedValues() {
        editedTitle = entry.title ?? ""
        editedContent = entry.content ?? ""
        editedTags = entry.tagsArray.joined(separator: ", ")
        editedDate = entry.date ?? Date()
    }
    
    private func saveChanges() {
        viewModel.updateEntry(
            entry,
            title: editedTitle,
            content: editedContent,
            date: editedDate,
            tags: editedTags.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
        )
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
