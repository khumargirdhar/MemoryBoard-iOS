//
//  NewEntryView.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 26/09/24.
//

import SwiftUI
import PhotosUI

struct NewEntryView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var entries: [JournalEntry]
    
    @State private var title = ""
    @State private var content = ""
    @State private var tags = ""
    @State private var image: UIImage? = nil
    @State private var selectedImages: [UIImage] = []
    @State private var showPhotoPicker = false
    
    var body: some View {
        NavigationView {
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
                    Button(action: {
                        showPhotoPicker = true
                    }) {
                        Text("Select Photos")
                    }
                    
                    // Display selected images as thumbnails
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
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
                            imageData: selectedImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
                        )
                        entries.append(newEntry)
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
            .sheet(isPresented: $showPhotoPicker) {
                PhotoPickerView(selectedImages: $selectedImages) // Photo picker for multiple image selection
            }
        }
    }
}


//struct NewEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewEntryView(entries: .constant([
//            JournalEntry(
//                title: "Sample Title",
//                content: "This is some sample content for a new journal entry.",
//                date: Date(),
//                tags: ["Sample", "Preview"],
//                imageData: nil
//            )
//        ]))
//    }
//}


