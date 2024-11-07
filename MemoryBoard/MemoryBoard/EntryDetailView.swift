import SwiftUI

struct EntryDetailView: View {
    var entry: JournalEntry
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var isPresentedAsSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                if let imageDataArray = entry.images, !imageDataArray.isEmpty {
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 15) {
                            ForEach(imageDataArray, id: \.self) { imagePath in
                                
                                if let uiImage = UIImage(contentsOfFile: imagePath) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 350, height: 350)
                                        .cornerRadius(10)
                                        .clipped()
                                } else {
                                    
                                    Color.gray
                                        .frame(width: 350, height: 350)
                                        .cornerRadius(10)
                                        .overlay(Text("Image not found").foregroundColor(.white))
                                }
                            }
                        }
                    }
                    .frame(height: 350)
                    .padding(.bottom, 20)
                }
                
                
                Text(entry.title)
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 5)
                
                
                Text(entry.content)
                    .font(.body)
                    .padding(.bottom, 20)
                
                
                if !entry.tags.isEmpty {
                    Text("Tags: \(entry.tags.joined(separator: ", "))")
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                }
            }
            .padding()
        }
        .navigationTitle(formattedDate(entry.date))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: dismissButton())
        .onAppear {
            
            if presentationMode.wrappedValue.isPresented {
                isPresentedAsSheet = true
            }
        }
    }
    
    
    private func dismissButton() -> some View {
        Group {
            if isPresentedAsSheet {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
