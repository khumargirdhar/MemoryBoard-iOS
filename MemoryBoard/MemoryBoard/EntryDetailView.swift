import SwiftUI

struct EntryDetailView: View {
    var entry: JournalEntry
    @Environment(\.dismiss) private var dismiss  // To dismiss the sheet
    @Environment(\.presentationMode) private var presentationMode // To detect modal presentation
    
    // A helper state to check if the view is being presented modally
    @State private var isPresentedAsSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Display the image gallery if there are any images
                if let imageDataArray = entry.images, !imageDataArray.isEmpty {
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 15) {
                            ForEach(imageDataArray, id: \.self) { imagePath in
                                // Ensure that the image exists and can be loaded from the file path
                                if let uiImage = UIImage(contentsOfFile: imagePath) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 350, height: 350)
                                        .cornerRadius(10)
                                        .clipped()
                                } else {
                                    // Placeholder image if the file does not exist
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
                
                // Display the title
                Text(entry.title)
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 5)
                
                // Display the content of the entry
                Text(entry.content)
                    .font(.body)
                    .padding(.bottom, 20)
                
                // Display the tags if any
                if !entry.tags.isEmpty {
                    Text("Tags: \(entry.tags.joined(separator: ", "))")
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                }
            }
            .padding()
        }
        .navigationTitle(formattedDate(entry.date))  // Display the formatted date as the title
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: dismissButton())  // Add the dismiss button
        .onAppear {
            // Check if the view is presented modally (as a sheet)
            if presentationMode.wrappedValue.isPresented {
                isPresentedAsSheet = true
            }
        }
    }
    
    // Dismiss button for when the view is presented as a sheet
    private func dismissButton() -> some View {
        Group {
            if isPresentedAsSheet {
                Button(action: {
                    dismiss()  // Dismiss the sheet when tapped
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    // Helper function to format the date
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
