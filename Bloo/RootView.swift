//
//  RootView.swift
//  Bloo
//

import SwiftUI
import SwiftData

/// Routes between onboarding and the main app, and publishes the active Bloo's
/// color as the app-wide accent (`blooAccentColor`) for the rest of the tree.
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
        .id(appLanguage) // forces a full re-render so already-resolved Text views re-localize
        .environment(\.blooAccentColor, accentColor)
        .environment(\.locale, Locale(identifier: appLanguage))
        .onChange(of: appLanguage) { _, newValue in
            LocalizationSwitcher.apply(languageCode: newValue)
        }
    }
}
