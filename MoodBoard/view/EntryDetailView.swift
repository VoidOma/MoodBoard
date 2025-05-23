//
//  EntryDetailView.swift
//  AppMeteo
//
//  Created by Milan Matejka on 5/23/25.
//

import SwiftUI

/// Vue détaillée affichant une entrée d’humeur avec sa photo, emoji, texte,
/// ainsi que les informations météo associées (icône, résumé, ville).
struct EntryDetailView: View {
    /// L’entrée MoodEntry à afficher
    let entry: MoodEntry
    
    /// Résumé météo (optionnel) — peut venir d'ailleurs ou être redondant avec entry.weatherSummary
    var weatherSummary: String?
    
    /// URL de l’icône météo (optionnel)
    var weatherIconURL: String?

    var body: some View {
        ZStack {
            // Fond rose pâle couvrant toute la zone sûre
            Color(red: 1.0, green: 0.94, blue: 0.95).ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Date formatée en gros titre et en gras
                Text(formattedDate(entry.date))
                    .font(.largeTitle)
                    .bold()
                
                // Image affichée si convertible depuis les données binaires
                if let uiImage = UIImage(data: entry.imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .cornerRadius(12)
                }
                
                // Emoji de l’humeur en grande taille
                Text(entry.emoji)
                    .font(.system(size: 60))
                
                // Description de l’humeur
                Text(entry.moodText)
                    .font(.title2)
                    .padding()
                
                // Icône météo chargée depuis l’URL si disponible
                if let iconURL = entry.weatherIconURL,
                   let url = URL(string: "https:\(iconURL)") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(width: 40, height: 40)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                // Résumé météo (optionnel)
                if let summary = entry.weatherSummary {
                    Text(summary)
                        .font(.caption)
                }
                
                // Nom de la ville (optionnel), avec un emoji localisation et texte gris
                if let city = entry.weatherCity {
                    Text("📍 \(city)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Affiche à nouveau le résumé météo (optionnel), en plus petit et gris
                if let weatherSummary = entry.weatherSummary {
                    Text(weatherSummary)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
        }
    }

    /// Formatte une date en chaîne lisible, par ex. "23 mai 2025"
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: date)
    }
}
