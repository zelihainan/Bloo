//
//  NameBlooView.swift
//  Bloo
//

import SwiftUI

struct NameBlooView: View {
    let species: BlooSpecies
    @Binding var name: String
    var onBack: (() -> Void)? = nil
    let onContinue: () -> Void

    private let nameCharacterLimit = 24

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

            BlooArtworkView(species: species, showsBackdrop: false)
                .frame(width: 200, height: 200)
                .frame(maxWidth: .infinity)

            Spacer()

            TextField("Give it a name...", text: $name)
                .font(.bloo(17))
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .blooFieldBackground()
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
    }
}
