import SwiftUI

struct NameBlooView: View {
    let species: BlooSpecies
    @Binding var name: String
    var onBack: (() -> Void)? = nil
    var celebratesUnlock: Bool = false
    let onContinue: () -> Void

    private let nameCharacterLimit = 24

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showConfetti = false
    @FocusState private var isNameFieldFocused: Bool

    private var trimmedName: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let onBack {
                Spacer().frame(height: 12)
                OnboardingBackButton(action: onBack)
                Spacer().frame(height: 20)
            } else {
                Spacer().frame(height: 60)
            }

            Text("What's your Bloo's name?")
                .font(.bloo(30, weight: .semibold))
            Text("This name is just between you two.")
                .font(.bloo(17))
                .foregroundStyle(.secondary)

            Spacer()

            ZStack {
                CharacterHabitatView(speciesHex: species.colorHex)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 22)
                AnimatedBlooPortraitView(species: species, size: 190)
            }
            .transaction { $0.animation = nil }

            Spacer()

            TextField("Give it a name...", text: $name)
                .font(.bloo(17))
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .blooFieldBackground()
                .focused($isNameFieldFocused)
                .submitLabel(.done)
                .onSubmit { isNameFieldFocused = false }
                .onChange(of: name) { _, newValue in
                    if newValue.count > nameCharacterLimit {
                        name = String(newValue.prefix(nameCharacterLimit))
                    }
                }

            Spacer()
            Spacer()

            Button("Continue", action: onContinue)
                .buttonStyle(.bloo(isEnabled: !trimmedName.isEmpty))
                .disabled(trimmedName.isEmpty)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlooTheme.background)
        .environment(\.blooAccentColor, Color(hex: species.colorHex))
        .overlay {
            if showConfetti {
                ConfettiView(colors: [Color(hex: species.colorHex), .yellow, .pink, .white])
            }
        }
        .task(id: species) {
            guard celebratesUnlock, !reduceMotion else { return }
            showConfetti = true
            try? await Task.sleep(for: .seconds(ConfettiView.totalDuration))
            guard !Task.isCancelled else { return }
            showConfetti = false
        }
    }
}
