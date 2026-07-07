//
//  ChooseBlooView.swift
//  Bloo
//

import SwiftUI

/// 3x3 grid of all 9 species. Only the 3 starters (`Bloo.state != .locked`) are
/// selectable at this point in onboarding — the rest show locked.
struct ChooseBlooView: View {
    let bloos: [Bloo]
    @Binding var selectedSpecies: BlooSpecies?
    let onContinue: () -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)

    private var sortedBloos: [Bloo] {
        bloos.sorted { $0.speciesRawValue < $1.speciesRawValue }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer().frame(height: 60)

            Text("Choose your Bloo")
                .font(.system(size: 32, weight: .semibold))
            Text("Pick your companion. It'll grow with you.")
                .font(.system(size: 17))
                .foregroundStyle(.secondary)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(sortedBloos) { bloo in
                    let isUnlocked = bloo.state != .locked
                    let isSelected = selectedSpecies == bloo.species

                    Button {
                        selectedSpecies = bloo.species
                    } label: {
                        BlooPlaceholderView(species: bloo.species, isLocked: !isUnlocked)
                            .aspectRatio(1, contentMode: .fit)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous)
                                    .stroke(
                                        isSelected ? Color(hex: bloo.species.colorHex) : BlooTheme.cardBorder,
                                        lineWidth: isSelected ? 2 : 1
                                    )
                            )
                    }
                    .disabled(!isUnlocked)
                }
            }
            .padding(.top, 28)

            Spacer()

            Button("Continue", action: onContinue)
                .buttonStyle(.bloo(isEnabled: selectedSpecies != nil))
                .disabled(selectedSpecies == nil)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlooTheme.background)
    }
}
