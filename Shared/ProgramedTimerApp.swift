//
//  ProgramedTimerApp.swift
//  Shared
//
//  Created by kentarou on 2022/04/23.
//

import SwiftUI

@main
struct ProgramedTimerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ListViewStatus())
        }
    }
}
