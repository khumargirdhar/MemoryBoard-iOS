import SwiftUI
import PhotosUI

struct NewEntryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: JournalViewModel
    
    @State private var title = ""
    @State private var content = ""
    @State private var tags = ""
    @State private var selectedImageItems: [PhotosPickerItem] = []
    @State private var selectedImagePaths: [String] = []
    @State private var selectedDate = Date()
    
    init() {
        _viewModel = StateObject(wrappedValue: JournalViewModel(context: CoreDataManager.shared.viewContext))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ReflectionCardView()
                
                Form {
                    Section(header: Text("Date")) {
                        DatePicker("Entry Date",
                                 selection: $selectedDate,
                                 displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                    }
                    
                    Section(header: Text("Title")) {
                        TextField("Enter title", text: $title)
                    }
                    
                    Section(header: Text("Content")) {
                        TextEditor(text: $content)
                            .frame(height: 200)
                    }
                    
                    Section(header: Text("Tags")) {
                        TextField("Enter tags separated by commas", text: $tags)
                    }
                    
                    Section(header: Text("Photos")) {
                        if !selectedImagePaths.isEmpty {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(selectedImagePaths, id: \.self) { imagePath in
                                        if let uiImage = UIImage(contentsOfFile: imagePath) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                        
                        PhotosPicker("Select Photos", selection: $selectedImageItems, matching: .images)
                            .onChange(of: selectedImageItems) { newItems in
                                Task {
                                    selectedImagePaths = []
                                    for item in newItems {
                                        if let data = try? await item.loadTransferable(type: Data.self) {
                                            if let filePath = saveImageToFile(data: data) {
                                                selectedImagePaths.append(filePath)
                                            }
                                        }
                                    }
                                }
                            }
                    }
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addEntry(
                            title,
                            content: content,
                            date: selectedDate,
                            tags: tags.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) },
                            imagePaths: selectedImagePaths
                        )
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
    
    private func saveImageToFile(data: Data) -> String? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
}
