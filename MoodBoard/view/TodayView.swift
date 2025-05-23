//
//  TodayView.swift
//  AppMeteo
//
//  Created by Milan Matejka on 5/23/25.
//

import CoreLocation
import SwiftUI

// Fonction utilitaire pour afficher "Aujourd’hui" si la date est aujourd'hui,
// sinon la date formatée en "d MMMM yyyy"
private func dateLabel(for date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM yyyy"
    return Calendar.current.isDateInToday(date) ? "Aujourd’hui" : formatter.string(from: date)
}

/// Vue principale affichant la page "Aujourd’hui"
/// Permet de choisir une date, une image, une humeur avec emoji, et sauvegarder l'entrée avec météo
struct TodayView: View {
    @ObservedObject var vm: MoodViewModel                  // ViewModel des entrées
    @State private var image: UIImage? = nil                // Image choisie
    @State private var showImagePicker = false              // Bool pour afficher l'image picker
    @State private var moodText = ""                         // Texte de l'humeur
    @State private var emoji = "🙂"                          // Emoji sélectionné
    @State private var showSidebar = false                   // Affichage de la sidebar
    @State private var selectedDate = Date()                 // Date sélectionnée pour l'entrée
    @State private var showDatePicker = false                // Affichage du date picker
    @State private var selectedEntry: MoodEntry?             // Entrée sélectionnée dans la sidebar
    @StateObject private var locationManager = LocationManager() // Manager pour localisation GPS
    @StateObject private var weatherVM = WeatherViewModel()      // ViewModel météo

    var body: some View {
        NavigationView {
            ZStack {
                // Fond rose clair
                Color(red: 1.0, green: 0.94, blue: 0.95).ignoresSafeArea()

                VStack(spacing: 20) {
                    // En-tête avec date affichée et bouton pour dérouler date picker
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

                    // DatePicker graphique, apparait/disparait avec animation
                    if showDatePicker {
                        DatePicker("Choisir une date", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .transition(.opacity)
                    }

                    // Bouton pour sélectionner une image
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
                    
                    // Affichage de la météo si disponible, sinon message de chargement
                    if let weather = weatherVM.weather {
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
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

                    // Champ texte pour décrire la journée
                    TextField("Décris ta journée...", text: $moodText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Text("Ton humeur du jour")
                        .font(.headline)

                    // Sélecteur d’emoji custom
                    EmojiPicker(selectedEmoji: $emoji)
                    
                    // Bouton enregistrer, désactivé si image manquante ou humeur vide
                    Button("Enregistrer") {
                        guard let image = image else { return }
                        let weather = weatherVM.weather

                        // Supprime l’entrée existante pour la date sélectionnée (évite doublon)
                        if let existingIndex = vm.entries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) {
                            vm.entries.remove(at: existingIndex)
                        }

                        // Ajout de la nouvelle entrée avec toutes les infos
                        vm.addEntry(
                            for: selectedDate,
                            image: image,
                            mood: moodText,
                            emoji: emoji,
                            weatherSummary: weather?.current.condition.text,
                            weatherIconURL: weather?.current.condition.icon,
                            weatherCity: weather?.location.name
                        )

                        // Réinitialisation du formulaire
                        moodText = ""
                        emoji = "🙂"
                        self.image = nil
                        selectedDate = Date()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(image == nil || moodText.isEmpty)

                    Spacer()
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // Bouton hamburger pour ouvrir/fermer la sidebar
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation {
                                showSidebar.toggle()
                                showDatePicker = false       // Ferme le date picker si ouvert
                                selectedEntry = nil          // Désélectionne l'entrée affichée
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                }

                // Dès que la localisation change, on récupère la météo correspondante
                .onChange(of: locationManager.location) { newLocation in
                    if let loc = newLocation {
                        weatherVM.fetchWeather(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude)
                    }
                }

                // Affiche la sidebar en overlay quand showSidebar est vrai, avec animation
                if showSidebar {
                    SidebarView(vm: vm, showSidebar: $showSidebar, selectedEntry: $selectedEntry)
                        .transition(.move(edge: .leading))
                        .onChange(of: showSidebar) { isShown in
                            if !isShown {
                                selectedEntry = nil
                            }
                        }
                }

                // Affiche le détail d’une entrée sélectionnée en overlay (à droite)
                if let entry = selectedEntry {
                    EntryDetailView(entry: entry)
                        .background(Color.white)
                        .transition(.move(edge: .trailing))
                }
            }
        }
        // Présente la vue de sélection d’image quand demandé
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $image)
        }
        // Ferme le date picker automatiquement quand on change la date
        .onChange(of: selectedDate) { _ in
            showDatePicker = false
        }
    }
}
