//
//  Modele.swift
//  MoodBoard
//
//  Created by Milan Matejka on 5/16/25.
//

import SwiftUI

struct SidebarView: View {
    @ObservedObject var vm: MoodViewModel
    @Binding var showSidebar: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("Mes Humeurs")
                .font(.title)
                .padding(.top, 50)
                .padding(.horizontal)

            ScrollView {
                ForEach(vm.entries) { entry in
                    let isToday = Calendar.current.isDateInToday(entry.date)
                    let dateText = isToday ? "Aujourd’hui" : formatDate(entry.date)

                    HStack {
                        Text("(entry.emoji)  (dateText)")
                            .padding(.vertical, 4)
                            .padding(.horizontal)
                            .onTapGesture {
                                // future : ouvrir une page dédiée ?
                                showSidebar = false
                            }
                        Spacer()
                    }
                }
            }

            Spacer()
        }
        .frame(width: 260)
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: date)
    }
}
