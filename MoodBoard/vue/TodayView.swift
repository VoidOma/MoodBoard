import SwiftUI

struct EmojiPicker: View {
    @Binding var selectedEmoji: String
    let emojis = [
        "😀", "😌", "😢", "😠", "😴", "😎", "🤯", "🥳", "😕", "😍",
        "🐶", "🐱", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐸", "🐵",
        "🍎", "🍌", "🍕", "🍔", "🍣", "🍩", "☕️", "🍺", "🥗", "🍰",
        "⚽️", "🏀", "🏓", "🏄‍♂️", "🚴‍♀️", "🎸", "🎮", "🎯", "🎲", "🎬",
        "📱", "💻", "⌚️", "🔑", "📚", "🕯️", "💡", "🔨", "✈️", "🚗",
        "❤️", "💔", "✨", "🔥", "⚡️", "🎉", "❄️", "🌈", "☀️", "🌙"
    ]

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
    @State private var image: UIImage? = nil
    @State private var showImagePicker = false
    @State private var moodText = ""
    @State private var emoji = "🙂"
    @State private var showSidebar = false
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var selectedEntry: MoodEntry?
    @StateObject private var locationManager = LocationManager()
    @StateObject private var weatherVM = WeatherViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    HStack {
                        Text(dateLabel(for: selectedDate))
                            .font(.largeTitle)
                            .bold()

                        Button(action: {
                            withAnimation {
                                showDatePicker.toggle()
                            }
                        }) {
                            Image(systemName: "chevron.down")
                                .rotationEffect(.degrees(showDatePicker ? 180 : 0))
                                .padding(.leading, 5)
                        }
                    }

                    if showDatePicker {
                        DatePicker("Choisir une date", selection: $selectedDate, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .transition(.opacity)
                    }

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

                    if let weather = weatherVM.weather {
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: "https:\\(weather.current.condition.icon)")) { image in
                                image.resizable().frame(width: 40, height: 40)
                            } placeholder: {
                                ProgressView()
                            }

                            VStack(alignment: .leading) {
                                Text(weather.location.name)
                                    .font(.caption)
                                    .bold()
                                Text("\(weather.current.temp_c, specifier: "%.1f")°C - \(weather.current.condition.text)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        Text("📍 Chargement de la météo...")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Button("Enregistrer") {
                        if let image = image {
                            vm.addEntry(for: selectedDate, image: image, mood: moodText, emoji: emoji)

                            moodText = ""
                            emoji = "🙂"
                            self.image = nil
                            selectedDate = Date()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(image == nil || moodText.isEmpty)

                    Spacer()
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { showSidebar.toggle() }) {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                }
                .onChange(of: locationManager.location) { newLocation in
                    if let loc = newLocation {
                        weatherVM.fetchWeather(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude)
                    }
                }

                if showSidebar {
                    SidebarView(vm: vm, showSidebar: $showSidebar, selectedEntry: $selectedEntry)
                        .transition(.move(edge: .leading))
                        .onChange(of: showSidebar) { isShown in
                            if !isShown {
                                selectedEntry = nil
                            }
                        }
                }

                if let entry = selectedEntry {
                    EntryDetailView(entry: entry)
                        .background(Color.white)
                        .transition(.move(edge: .trailing))
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $image)
        }
        .onChange(of: selectedDate) { _ in
            showDatePicker = false
        }
    }

    private func dateLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return Calendar.current.isDateInToday(date) ? "Aujourd’hui" : formatter.string(from: date)
    }
}
