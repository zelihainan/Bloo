//
//  GrowthCardView.swift
//  Bloo
//

import SwiftUI

/// The Bloo's name, its circle portrait, growth progress bar, and the
/// "{name} is growing" caption.
struct GrowthCardView: View {
    let bloo: Bloo

    private var accentColor: Color { Color(hex: bloo.species.colorHex) }
    private var backdropColor: Color { Color.pastel(hex: bloo.species.colorHex) }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(backdropColor)
                    .frame(width: 219, height: 219)
                BlooArtworkView(species: bloo.species, showsBackdrop: false)
                    .frame(width: 190, height: 190)
            }

            VStack(spacing: 6) {
                ZStack(alignment: .leading) {
                    Capsule().fill(BlooTheme.cardBorder).frame(height: 5)
                    Capsule().fill(accentColor).frame(width: 260 * bloo.stageProgress, height: 5)
                }
                .frame(width: 260)

                Text(String(format: NSLocalizedString("%@ is growing 🌱", comment: ""), bloo.displayName))
                    .font(.bloo(11, italic: true))
                    .foregroundStyle(BlooTheme.secondaryText)
                    .frame(width: 260, alignment: .trailing)
            }
        }
    }
}
