//
//  MoodViewModel.swift
//  AppMeteo
//
//  Created by Milan Matejka on 5/23/25.
//

//
//  Modele.swift
//  MoodBoard
//
//  Created by Milan Matejka on 5/16/25.
//


import Foundation
import SwiftUI

class MoodViewModel: ObservableObject {
    @Published var entries: [MoodEntry] = []
    private let storageKey = "MoodEntries"

    init() {
        loadEntries()
    }

    func addEntry(for date: Date, image: UIImage, mood: String, emoji: String, weatherSummary: String?, weatherIconURL: String?, weatherCity: String?) {
        let imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
        let entry = MoodEntry(
            date: date,
            imageData: imageData,
            moodText: mood,
            emoji: emoji,
            weatherSummary: weatherSummary,
            weatherIconURL: weatherIconURL,
            weatherCity: weatherCity
        )
        entries.append(entry)
        saveEntries()
    }

    func saveEntries() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(entries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([MoodEntry].self, from: data) {
                entries = decoded
            }
        }
    }
}
