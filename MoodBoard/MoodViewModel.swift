//
//  Modele.swift
//  MoodBoard
//
//  Created by Milan Matejka on 5/16/25.
//

import SwiftUI

class MoodViewModel: ObservableObject {
    @Published var entries: [MoodEntry] = []

    init() {
        load()
    }

    func addEntry(for date: Date, image: UIImage, mood: String, emoji: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let newEntry = MoodEntry(id: UUID(), date: date, moodText: mood, emoji: emoji, imageData: data)

        // Supprimer une ancienne entrée pour cette date
        entries.removeAll { Calendar.current.isDate($0.date, inSameDayAs: date) }

        entries.insert(newEntry, at: 0)
        save()
    }


    private func save() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "moodEntries")
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: "moodEntries"),
           let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            self.entries = decoded
        }
    }
}
