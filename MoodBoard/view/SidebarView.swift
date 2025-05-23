//
//  SidebarView.swift
//  AppMeteo
//
//  Created by Milan Matejka on 5/23/25.
//

import SwiftUI
import Foundation

// Extension pratique pour manipuler facilement les dates
extension Date {
    /// Indique si la date est aujourd'hui
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Indique si la date est dans les N derniers jours (excluant aujourd'hui)
    func isInLastNDays(_ days: Int) -> Bool {
        guard let nDaysAgo = Calendar.current.date(byAdding: .day, value: -days, to: Date()) else {
            return false
        }
        return self >= nDaysAgo && self < Date()
    }
}

// Fonction privée pour formater une date en chaîne, exemple : "23 mai 2025"
private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM yyyy"
    return formatter.string(from: date)
}

// Vue réutilisable pour une ligne dans la liste, affichant emoji + date
private func entryRow(_ entry: MoodEntry) -> some View {
    NavigationLink {
        EntryDetailView(entry: entry) // Vue détaillée quand on clique
    } label: {
        Text("\(entry.emoji) \(formattedDate(entry.date))")
    }
}

/// Vue affichant la barre latérale listant les entrées par périodes :
/// Aujourd'hui, 7 derniers jours, 30 derniers jours, plus ancien
struct SidebarView: View {
    @ObservedObject var vm: MoodViewModel  // ViewModel contenant les entrées
    @Binding var showSidebar: Bool          // Pour gérer l’affichage de la sidebar (utile sur iPad/Mac)
    @Binding var selectedEntry: MoodEntry?  // Entrée sélectionnée actuellement

    var body: some View {
        List {
            // Section des entrées d’aujourd’hui
            Section("Aujourd’hui") {
                ForEach(vm.entries.filter { Calendar.current.isDateInToday($0.date) }) { entry in
                    entryRow(entry)
                }
            }

            // Section des entrées des 7 derniers jours, hors aujourd’hui
            Section("7 derniers jours") {
                ForEach(vm.entries.filter {
                    !$0.date.isToday && $0.date.isInLastNDays(7)
                }) { entry in
                    entryRow(entry)
                }
            }

            // Section des entrées des 30 derniers jours hors 7 derniers jours et hors aujourd’hui
            Section("30 derniers jours") {
                ForEach(vm.entries.filter {
                    !$0.date.isInLastNDays(7) &&
                    $0.date >= Calendar.current.date(byAdding: .day, value: -30, to: Date())! &&
                    !$0.date.isToday
                }) { entry in
                    entryRow(entry)
                }
            }

            // Section des entrées plus anciennes que 30 jours
            Section("Plus ancien") {
                ForEach(vm.entries.filter {
                    $0.date < Calendar.current.date(byAdding: .day, value: -30, to: Date())!
                }) { entry in
                    entryRow(entry)
                }
            }
        }
        .navigationTitle("Mes Humeurs")
    }
}
