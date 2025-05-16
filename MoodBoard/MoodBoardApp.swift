//
//  MoodBoardApp.swift
//  MoodBoard
//
//  Created by Milan Matejka on 5/16/25.
//

import SwiftUI

@main
struct MoodBoardApp: App {
    @StateObject private var vm = MoodViewModel()

    var body: some Scene {
        WindowGroup {
            TodayView(vm: vm)
        }
    }
}
