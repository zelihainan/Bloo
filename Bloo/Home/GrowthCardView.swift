//
//  GrowthCardView.swift
//  Bloo
//
//  Pixel values below are taken directly from Figma dev-mode inspector
//  (file a56NftgrLPHxVvl81NALmO, node 5:109 "05 - Home"), not estimated.
//

import SwiftUI

/// The Bloo circle, its growth progress bar, and the "{name} is growing" caption.
struct GrowthCardView: View {
    let bloo: Bloo

    private var accentColor: Color { Color(hex: bloo.species.colorHex) }
    private var backdropColor: Color { Color.pastel(hex: bloo.species.colorHex) }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(backdropColor)
                    .frame(width: 219, height: 219)
                BlooArtworkView(species: bloo.species, showsBackdrop: false)
                    .frame(width: 190, height: 190)
            }

            Spacer().frame(height: 20)

            ZStack(alignment: .leading) {
                Capsule().fill(BlooTheme.cardBorder).frame(width: 178, height: 4)
                Capsule().fill(accentColor).frame(width: 178 * bloo.stageProgress, height: 4)
            }
            .frame(width: 178)

            Spacer().frame(height: 3)

            Text("\(bloo.displayName) is growing 🌱")
                .font(.bloo(7, weight: .light, italic: true))
                .foregroundStyle(BlooTheme.secondaryText)
                .frame(width: 178, alignment: .trailing)
        }
    }
}
