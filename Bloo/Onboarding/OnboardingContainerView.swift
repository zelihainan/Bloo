import SwiftUI
import SwiftData

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
