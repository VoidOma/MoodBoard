//
//  Modele.swift
//  MoodBoard
//
//  Created by Milan Matejka on 5/16/25.
//

import Foundation

struct MoodEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    var moodText: String
    var emoji: String
    var imageData: Data
}
