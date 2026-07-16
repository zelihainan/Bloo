import SwiftUI
import SwiftData

struct RootView: View {
    @AppStorage(AppStorageKey.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @AppStorage(AppStorageKey.appLanguage) private var appLanguage = "en"
    @Query(filter: #Predicate<Bloo> { $0.stateRawValue == "active" }) private var activeBloos: [Bloo]

    private var accentColor: Color {
        guard let active = activeBloos.first else { return BlooTheme.primaryButtonBackground }
        return Color(hex: active.species.colorHex)
    }

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingContainerView()
            }
        }
        .id(appLanguage)
        .environment(\.blooAccentColor, accentColor)
        .environment(\.locale, Locale(identifier: appLanguage))
        .onChange(of: appLanguage) { _, newValue in
            LocalizationSwitcher.apply(languageCode: newValue)
        }
    }
}
