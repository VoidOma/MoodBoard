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

struct SidebarView: View {
    @ObservedObject var vm: MoodViewModel
    @Binding var showSidebar: Bool
    @Binding var selectedEntry: MoodEntry?

    var body: some View {
        List {
            Section("Aujourd’hui") {
                ForEach(vm.entries.filter { Calendar.current.isDateInToday($0.date) }) { entry in
                    NavigationLink {
                        EntryDetailView(entry: entry)
                    } label: {
                        Text("\(entry.emoji) \(formattedDate(entry.date))")
                    }
                }
            }

            Section("7 derniers jours") {
                ForEach(vm.entries.filter {
                    !$0.date.isToday && $0.date.isInLastNDays(7)
                }) { entry in
                    NavigationLink {
                        EntryDetailView(entry: entry)
                    } label: {
                        Text("\(entry.emoji) \(formattedDate(entry.date))")
                    }
                }
            }

            Section("Mois précédent") {
                ForEach(vm.entries.filter {
                    Calendar.current.isDate($0.date, equalTo: Date().addingTimeInterval(-30*24*60*60), toGranularity: .month)
                }) { entry in
                    NavigationLink {
                        EntryDetailView(entry: entry)
                    } label: {
                        Text("\(entry.emoji) \(formattedDate(entry.date))")
                    }
                }
            }

            Section("Année précédente") {
                ForEach(vm.entries.filter {
                    $0.date < Calendar.current.date(byAdding: .year, value: -1, to: Date())!
                }) { entry in
                    NavigationLink {
                        EntryDetailView(entry: entry)
                    } label: {
                        Text("\(entry.emoji) \(formattedDate(entry.date))")
                    }
                }
            }
        }
        .navigationTitle("Mes Humeurs")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: date)
    }
}
