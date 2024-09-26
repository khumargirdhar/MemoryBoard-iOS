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
    @State private var selectedImage: PhotosPickerItem? = nil
    
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
                
                Section {
                    PhotosPicker(selection: $selectedImage, matching: .images) {
                        Text("Pick Image")
                    }
                    .onChange(of: selectedImage) { newValue in
                        if let newValue = newValue {
                            Task {
                                if let data = try? await newValue.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    self.image = uiImage
                                }
                            }
                        }
                    }
                    
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }
            }
            .navigationTitle("New Entry")
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
                            imageData: image?.jpegData(compressionQuality: 0.8)
                        )
                        entries.append(newEntry)
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
}


struct NewEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NewEntryView(entries: .constant([
            JournalEntry(
                title: "Sample Title",
                content: "This is some sample content for a new journal entry.",
                date: Date(),
                tags: ["Sample", "Preview"],
                imageData: nil
            )
        ]))
    }
}


