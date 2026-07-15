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
    init() {
        let languageCode = UserDefaults.standard.string(forKey: AppStorageKey.appLanguage) ?? "en"
        LocalizationSwitcher.apply(languageCode: languageCode)
    }

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
                // The whole design system (BlooTheme, Color+Hex, every
                // species/backdrop color) is hand-tuned for a light, pastel
                // look with no dark-mode counterparts. Pinning the color
                // scheme makes that a deliberate choice instead of an
                // accidental half-adaptation where system chrome (alerts,
                // keyboard) would go dark while the app's own UI stays light.
                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)
    }
}
