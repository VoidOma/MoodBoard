//
//  SidebarView.swift
//  AppMeteo
//
//  Created by Milan Matejka on 5/23/25.
//

import SwiftUI
import Foundation

extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    func isInLastNDays(_ days: Int) -> Bool {
        guard let nDaysAgo = Calendar.current.date(byAdding: .day, value: -days, to: Date()) else {
            return false
        }
        return self >= nDaysAgo && self < Date()
    }
}

private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM yyyy"
    return formatter.string(from: date)
}


private func entryRow(_ entry: MoodEntry) -> some View {
    NavigationLink {
        EntryDetailView(entry: entry)
    } label: {
        Text("\(entry.emoji) \(formattedDate(entry.date))")
    }
}


struct SidebarView: View {
    @ObservedObject var vm: MoodViewModel
    @Binding var showSidebar: Bool
    @Binding var selectedEntry: MoodEntry?

    var body: some View {
        List {
            Section("Aujourd’hui") {
                ForEach(vm.entries.filter { Calendar.current.isDateInToday($0.date) }) { entry in
                    entryRow(entry)
                }
            }

            Section("7 derniers jours") {
                ForEach(vm.entries.filter {
                    !$0.date.isToday && $0.date.isInLastNDays(7)
                }) { entry in
                    entryRow(entry)
                }
            }

            Section("30 derniers jours") {
                ForEach(vm.entries.filter {
                    !$0.date.isInLastNDays(7) &&
                    $0.date >= Calendar.current.date(byAdding: .day, value: -30, to: Date())! &&
                    !$0.date.isToday
                }) { entry in
                    entryRow(entry)
                }
            }

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
