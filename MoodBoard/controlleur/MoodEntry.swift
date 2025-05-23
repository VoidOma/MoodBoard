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
    var id = UUID()
    var date: Date
    var imageData: Data
    var moodText: String
    var emoji: String
    var weatherSummary: String?
    var weatherIconURL: String?
    var weatherCity: String?
}
