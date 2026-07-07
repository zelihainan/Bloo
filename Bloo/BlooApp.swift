//
//  BlooApp.swift
//  Bloo
//
//  Created by Zeliha İnan on 7.07.2026.
//

import SwiftUI
import SwiftData

@main
struct BlooApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Bloo.self,
            Habit.self,
            HabitCompletion.self,
            DailyLog.self,
            Badge.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            Bloo.bootstrapSpeciesIfNeeded(in: container.mainContext)
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
