//
//  RootView.swift
//  Bloo
//

import SwiftUI
import SwiftData

/// Routes between onboarding and the main app, and publishes the active Bloo's
/// color as the app-wide accent (`blooAccentColor`) for the rest of the tree.
struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
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
        .environment(\.blooAccentColor, accentColor)
    }
}
