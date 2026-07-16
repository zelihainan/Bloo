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
                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)
    }
}
