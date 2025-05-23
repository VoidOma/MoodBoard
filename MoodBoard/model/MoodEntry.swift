//
//  MoodEntry.swift
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

struct MoodEntry: Identifiable, Codable {
    var id = UUID()               // Identifiant unique pour chaque entrée (nécessaire pour SwiftUI)
    var date: Date               // Date de l’entrée mood
    var imageData: Data          // Image associée, stockée sous forme de données binaires (JPEG, PNG, etc.)
    var moodText: String         // Texte décrivant l’humeur ou la journée
    var emoji: String            // Emoji symbolisant l’humeur
    var weatherSummary: String?  // Résumé météo optionnel (ex: "Ensoleillé", "Pluvieux")
    var weatherIconURL: String?  // URL de l’icône météo optionnelle (pour affichage)
    var weatherCity: String?     // Nom de la ville associée à la météo optionnelle
}
