//
//  EntryDetailView.swift
//  AppMeteo
//
//  Created by Milan Matejka on 5/23/25.
//

import SwiftUI

struct EntryDetailView: View {
    let entry: MoodEntry
    var weatherSummary: String?
    var weatherIconURL: String?


    var body: some View {
        VStack(spacing: 20) {
            Text(formattedDate(entry.date))
                .font(.largeTitle)
                .bold()

            if let uiImage = UIImage(data: entry.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
            }

            Text(entry.emoji)
                .font(.system(size: 60))
            
            Text(entry.moodText)
                .font(.title2)
                .padding()
            
            if let iconURL = entry.weatherIconURL,
               let url = URL(string: "https:\(iconURL)") {
                AsyncImage(url: url) { image in
                    image.resizable().frame(width: 40, height: 40)
                } placeholder: {
                    ProgressView()
                }
            }

            if let summary = entry.weatherSummary {
                Text(summary)
                    .font(.caption)
            }

            if let city = entry.weatherCity {
                Text("📍 \(city)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }


            if let weatherSummary = entry.weatherSummary {
                Text(weatherSummary)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }


            Spacer()
        }
        .padding()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: date)
    }
}
