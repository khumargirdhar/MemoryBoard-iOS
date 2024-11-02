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
    @ObservedObject var viewModel: JournalViewModel
    
    @State private var title = ""
    @State private var content = ""
    @State private var tags = ""
    @State private var image: UIImage? = nil
    @State private var selectedImages: [Data] = []
    @State private var showPhotoPicker = false
    @State private var selectedImageItems: [PhotosPickerItem] = []
    
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
//                        Button(action: {
//                            showPhotoPicker = true
//                        }) {
//                            Text("Select Photos")
//                        }
                        
                        // Display selected images as thumbnails
                        if !selectedImages.isEmpty {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(selectedImages, id: \.self) { imageData in
                                        if let uiImage = UIImage(data: imageData) {
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
                                selectedImages = []
                                for item in newItems {
                                    item.loadTransferable(type: Data.self) { result in
                                        if case .success(let data) = result, let data = data {
                                            selectedImages.append(data)
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
                            images: selectedImages
                        )
                        entries.append(newEntry)
                        viewModel.addEntry(newEntry)
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
//            .sheet(isPresented: $showPhotoPicker) {
////                PhotoPickerView(selectedImages: $selectedImages) // Photo picker for multiple image selection
//                PhotosPicker("Select Photos", selection: $selectedImages, matching: .images)
//            }
        }
    }
}
