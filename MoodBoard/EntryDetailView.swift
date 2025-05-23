import SwiftUI

struct EntryDetailView: View {
    let entry: MoodEntry

    var body: some View {
        VStack(spacing: 20) {
            Text(formattedDate(entry.date))
                .font(.largeTitle)
                .bold()

            if let uiImage = UIImage(data: entry.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
            }

            Text(entry.emoji)
                .font(.system(size: 60))
            
            Text(entry.moodText)
                .font(.title2)
                .padding()

            Spacer()
        }
        .padding()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: date)
    }
}
