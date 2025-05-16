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

    func addEntry(image: UIImage, mood: String, emoji: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let newEntry = MoodEntry(id: UUID(), date: Date(), moodText: mood, emoji: emoji, imageData: data)

        // Supprimer l'entrée du jour si elle existe déjà
        entries.removeAll { Calendar.current.isDateInToday($0.date) }

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
