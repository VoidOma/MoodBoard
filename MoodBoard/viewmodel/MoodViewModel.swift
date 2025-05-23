//
//  MoodViewModel.swift
//  AppMeteo
//
//  Created by Milan Matejka on 5/23/25.
//

import Foundation
import SwiftUI

/// ViewModel qui gère les entrées de l’humeur (MoodEntry).
/// Responsable de la création, stockage et chargement des entrées.
class MoodViewModel: ObservableObject {
    /// Liste des entrées d’humeur affichées et modifiées dans l’interface.
    @Published var entries: [MoodEntry] = []
    
    /// Clé utilisée pour sauvegarder les données dans UserDefaults.
    private let storageKey = "MoodEntries"

    /// Initialisation : charge les entrées sauvegardées.
    init() {
        loadEntries()
    }

    /// Ajoute une nouvelle entrée à la liste et sauvegarde.
    /// - Parameters:
    ///   - date: Date de l'entrée
    ///   - image: Image associée (convertie en Data JPEG)
    ///   - mood: Description textuelle de l’humeur
    ///   - emoji: Emoji représentant l’humeur
    ///   - weatherSummary: Résumé météo (optionnel)
    ///   - weatherIconURL: URL de l’icône météo (optionnel)
    ///   - weatherCity: Nom de la ville (optionnel)
    func addEntry(for date: Date,
                  image: UIImage,
                  mood: String,
                  emoji: String,
                  weatherSummary: String?,
                  weatherIconURL: String?,
                  weatherCity: String?) {
        // Conversion de l’image en données compressées JPEG
        let imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
        
        // Création d’une nouvelle entrée MoodEntry
        let entry = MoodEntry(
            date: date,
            imageData: imageData,
            moodText: mood,
            emoji: emoji,
            weatherSummary: weatherSummary,
            weatherIconURL: weatherIconURL,
            weatherCity: weatherCity
        )
        
        // Ajout à la liste des entrées
        entries.append(entry)
        
        // Sauvegarde dans UserDefaults
        saveEntries()
    }

    /// Encode les entrées en JSON et les sauvegarde dans UserDefaults.
    func saveEntries() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(entries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    /// Charge les entrées sauvegardées depuis UserDefaults et les décode.
    func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([MoodEntry].self, from: data) {
                entries = decoded
            }
        }
    }
}
