import SwiftUI
import PhotosUI

struct NewEntryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: JournalViewModel
    
    @State private var title = ""
    @State private var content = ""
    @State private var tags = ""
    @State private var selectedImageItems: [PhotosPickerItem] = []
    @State private var selectedImagePaths: [String] = [] // Store file paths instead of Data
    
    var body: some View {
        NavigationView {
            VStack {
                
                ReflectionCardView()
                
                Form {
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
                        // Display selected images as thumbnails
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
                        
                        PhotosPicker("Select Photos", selection: $selectedImageItems, matching: .images, photoLibrary: .shared())
                            .onChange(of: selectedImageItems) { newItems in
                                selectedImagePaths = []
                                for item in newItems {
                                    item.loadTransferable(type: Data.self) { result in
                                        if case .success(let data) = result, let data = data {
                                            // Save image to file and store the path
                                            let filePath = saveImageToFile(data: data)
                                            selectedImagePaths.append(filePath)
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
                        let newEntry = JournalEntry(
                            title: title,
                            content: content,
                            date: Date(),
                            tags: tags.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) },
                            images: selectedImagePaths // Store paths
                        )
                        viewModel.addEntry(newEntry)
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
    
    private func saveImageToFile(data: Data) -> String {
        // Get the documents directory
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return ""
        }
        
        // Create a unique file name
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // Save the image data to the file
        do {
            try data.write(to: fileURL)
            return fileURL.path // Return the file path
        } catch {
            print("Error saving image: \(error)")
            return ""
        }
    }
}
