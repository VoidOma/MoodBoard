import SwiftUI

struct EmojiPicker: View {
    @Binding var selectedEmoji: String
    let emojis = ["😀", "😌", "😢", "😠", "😴", "😎", "🤯", "🥳", "😕", "😍"]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .font(.system(size: 40))
                        .padding(10)
                        .background(selectedEmoji == emoji ? Color.blue.opacity(0.2) : Color.clear)
                        .clipShape(Circle())
                        .onTapGesture {
                            selectedEmoji = emoji
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}


struct TodayView: View {
    @ObservedObject var vm: MoodViewModel
    @State private var image: UIImage?
    @State private var showImagePicker = false
    @State private var moodText = ""
    @State private var emoji = "🙂"
    @State private var showSidebar = false
    @State private var selectedEntry: MoodEntry? = nil

    var body: some View {
        NavigationView {
            ZStack {
                if let entry = selectedEntry {
                    EntryDetailView(entry: entry)
                } else {
                    VStack(spacing: 20) {
                        Text(dateLabel(for: Date()))
                            .font(.largeTitle)
                            .bold()

                        Button(action: { showImagePicker = true }) {
                            if let img = image {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 300)
                                    .cornerRadius(12)
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                        .frame(height: 200)
                                    Text("Ajouter une image")
                                }
                            }
                        }

                        TextField("Décris ta journée...", text: $moodText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        Text("Ton humeur du jour")
                            .font(.headline)

                        EmojiPicker(selectedEmoji: $emoji)

                        Button("Enregistrer") {
                            if let image = image {
                                vm.addEntry(image: image, mood: moodText, emoji: emoji)
                                self.image = nil
                                self.moodText = ""
                                self.emoji = "🙂"
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(image == nil || moodText.isEmpty)

                        Spacer()
                    }
                    .padding()
                }

                if showSidebar {
                    SidebarView(vm: vm, showSidebar: $showSidebar, selectedEntry: $selectedEntry)
                        .transition(.move(edge: .leading))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showSidebar.toggle() }) {
                        Image(systemName: "line.3.horizontal")
                    }
                }

                if selectedEntry != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Fermer") {
                            selectedEntry = nil
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $image)
        }
    }

    private func dateLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return Calendar.current.isDateInToday(date) ? "Aujourd’hui" : formatter.string(from: date)
    }
}
