//
//  habitsApp.swift
//  habits
//
//  Created by Julien THIBEAUT on 22/03/2023.
//

import SwiftUI

@main
struct habitsApp: App {
    let habitData = HabitData()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(habitData)
        }
    }
}
