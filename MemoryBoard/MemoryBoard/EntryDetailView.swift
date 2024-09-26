//
//  EntryDetailView.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 26/09/24.
//

import SwiftUI

struct EntryDetailView: View {
    var entry: JournalEntry
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
//                if let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 300)
//                        .cornerRadius(20)
//                        .padding(.bottom)
//                }
                
                // Display the image gallery if there are any images
                if let imageDataArray = entry.imageData, !imageDataArray.isEmpty {
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(imageDataArray, id: \.self) { data in
                                if let image = UIImage(data: data) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 400, height: 400)
                                        .cornerRadius(10)
                                        .clipped()
                                }
                            }
                        }
                    }
                    .frame(height: 400)
                }
                
                Text(entry.title)
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 5)
                
                Text(entry.content)
                    .padding(.bottom, 20)
                
                Text("Tags: \(entry.tags.joined(separator: ", "))")
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .navigationTitle(formattedDate(entry.date))       // Enter Date Here
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
}


struct EntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EntryDetailView(entry: JournalEntry(title: "Test", content: "Test Content", date: Date.now, tags: []))
    }
}
