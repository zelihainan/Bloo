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
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Group {
            switch step {
            case .welcome:
                OnboardingWelcomeView { advance(to: .chooseBloo) }
            case .chooseBloo:
                ChooseBlooView(bloos: bloos, selectedSpecies: $selectedSpecies, onBack: { advance(to: .welcome) }) {
                    advance(to: .nameBloo)
                }
            case .nameBloo:
                if let species = selectedSpecies {
                    NameBlooView(species: species, name: $blooName, onBack: { advance(to: .chooseBloo) }) {
                        activateChosenBloo(species: species)
                        advance(to: .addHabits)
                    }
                }
            case .addHabits:
                OnboardingAddHabitsView(blooName: blooName.trimmingCharacters(in: .whitespacesAndNewlines), onBack: { advance(to: .nameBloo) }) {
                    hasCompletedOnboarding = true
                }
            }
        }
        .id(step)
        .transition(reduceMotion ? .opacity : .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
    }

    private func advance(to newStep: Step) {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.35)) {
            step = newStep
        }
    }

    /// Only one Bloo can ever be `.active` — if onboarding's back button was
    /// used to pick a different species after an earlier one was already
    /// activated here, that earlier one needs to stand down first (otherwise
    /// both end up `.active` and whichever the next `@Query` happens to pick
    /// first — not necessarily this one — silently wins everywhere else in
    /// the app, from Home's accent color to the habit form's).
    private func activateChosenBloo(species: BlooSpecies) {
        guard let bloo = bloos.first(where: { $0.species == species }) else { return }
        for other in bloos where other.state == .active && other.id != bloo.id {
            other.state = .unlocked
        }
        bloo.state = .active
        bloo.activatedAt = Date()
        bloo.customName = blooName.trimmingCharacters(in: .whitespacesAndNewlines)
        modelContext.saveAndLogErrors()
    }
}
