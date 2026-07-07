//
//  NameBlooView.swift
//  Bloo
//

import SwiftUI

struct NameBlooView: View {
    let species: BlooSpecies
    @Binding var name: String
    let onContinue: () -> Void

    private var trimmedName: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer().frame(height: 60)

            Text("What's your Bloo's name?")
                .font(.bloo(30, weight: .semibold))
            Text("This name is just between you two.")
                .font(.bloo(17))
                .foregroundStyle(.secondary)

            Spacer()

            BlooPlaceholderView(species: species)
                .frame(width: 200, height: 200)
                .frame(maxWidth: .infinity)

            Spacer()

            TextField("Give it a name...", text: $name)
                .font(.bloo(17))
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .blooFieldBackground()

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
