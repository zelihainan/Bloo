//
//  OnboardingContainerView.swift
//  Bloo
//

import SwiftUI
import SwiftData

/// Drives the 4-screen onboarding flow: egg intro -> choose Bloo -> name Bloo -> first habits.
struct OnboardingContainerView: View {
    private enum Step {
        case welcome, chooseBloo, nameBloo, addHabits
    }

    @Environment(\.modelContext) private var modelContext
    @Query private var bloos: [Bloo]

    @State private var step: Step = .welcome
    @State private var selectedSpecies: BlooSpecies?
    @State private var blooName: String = ""

    @AppStorage(AppStorageKey.hasCompletedOnboarding) private var hasCompletedOnboarding = false

    var body: some View {
        Group {
            switch step {
            case .welcome:
                OnboardingWelcomeView { step = .chooseBloo }
            case .chooseBloo:
                ChooseBlooView(bloos: bloos, selectedSpecies: $selectedSpecies, onBack: { step = .welcome }) {
                    step = .nameBloo
                }
            case .nameBloo:
                if let species = selectedSpecies {
                    NameBlooView(species: species, name: $blooName, onBack: { step = .chooseBloo }) {
                        activateChosenBloo(species: species)
                        step = .addHabits
                    }
                }
            case .addHabits:
                OnboardingAddHabitsView(onBack: { step = .nameBloo }) {
                    hasCompletedOnboarding = true
                }
            }
        }
    }

    private func activateChosenBloo(species: BlooSpecies) {
        guard let bloo = bloos.first(where: { $0.species == species }) else { return }
        bloo.state = .active
        bloo.activatedAt = Date()
        bloo.customName = blooName.trimmingCharacters(in: .whitespacesAndNewlines)
        try? modelContext.save()
    }
}
