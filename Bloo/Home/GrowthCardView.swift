//
//  GrowthCardView.swift
//  Bloo
//

import SwiftUI

/// The Bloo's name, its circle portrait, growth progress bar, and the
/// "{name} is growing" caption.
struct GrowthCardView: View {
    let bloo: Bloo

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var accentColor: Color { Color(hex: bloo.species.colorHex) }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                CharacterHabitatView(speciesHex: bloo.species.colorHex)
                AnimatedBlooPortraitView(species: bloo.species)
            }
            .id(bloo.species)
            .transition(.opacity)
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.4), value: bloo.species)

            VStack(spacing: 6) {
                ZStack(alignment: .leading) {
                    Capsule().fill(BlooTheme.cardBorder).frame(height: 5)
                    Capsule().fill(accentColor).frame(width: 260 * bloo.stageProgress, height: 5)
                        .animation(reduceMotion ? nil : .easeOut(duration: 0.6), value: bloo.stageProgress)
                }
                .frame(width: 260)

                Text(String(format: NSLocalizedString("%@ is growing 🌱", comment: ""), bloo.displayName))
                    .font(.bloo(11, italic: true))
                    .foregroundStyle(BlooTheme.secondaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(width: 260, alignment: .trailing)
            }
        }
    }
}
