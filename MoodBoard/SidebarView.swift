import SwiftUI

struct SidebarView: View {
    @ObservedObject var vm: MoodViewModel
    @Binding var showSidebar: Bool
    @Binding var selectedEntry: MoodEntry?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Mes Humeurs")
                .font(.title)
                .padding(.top, 50)
                .padding(.horizontal)

            ScrollView {
                ForEach(sectionedEntries.keys.sorted(by: >), id: \.self) { section in
                    Text(section)
                        .font(.headline)
                        .padding(.horizontal)

                    ForEach(sectionedEntries[section] ?? []) { entry in
                        HStack {
                            Text("\(entry.emoji)  \(formatDate(entry.date))")
                                .padding(.vertical, 4)
                                .padding(.horizontal)
                                .onTapGesture {
                                    selectedEntry = entry
                                    showSidebar = false
                                }
                            Spacer()
                        }
                    }
                }
            }
            Spacer()
        }
        .frame(width: 260)
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }

    private var sectionedEntries: [String: [MoodEntry]] {
        let calendar = Calendar.current
        var sections: [String: [MoodEntry]] = [:]
        let today = Date()

        for entry in vm.entries {
            if calendar.isDateInToday(entry.date) {
                sections["Aujourd’hui", default: []].append(entry)
            } else if let days = calendar.dateComponents([.day], from: entry.date, to: today).day, days <= 7 {
                sections["7 derniers jours", default: []].append(entry)
            } else if calendar.isDate(entry.date, equalTo: today, toGranularity: .month) {
                sections["Ce mois-ci", default: []].append(entry)
            } else if calendar.isDate(entry.date, equalTo: today, toGranularity: .year) {
                sections["Cette année", default: []].append(entry)
            } else {
                sections["Années précédentes", default: []].append(entry)
            }
        }

        return sections
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: date)
    }
}
