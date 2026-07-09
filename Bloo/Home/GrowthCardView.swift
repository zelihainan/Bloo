//
//  GrowthCardView.swift
//  Bloo
//

import SwiftUI

/// The big Bloo circle, its growth progress bar, and the "{name} is growing" caption.
struct GrowthCardView: View {
    let bloo: Bloo

    private var accentColor: Color { Color(hex: bloo.species.colorHex) }

    var body: some View {
        VStack(spacing: 12) {
            BlooArtworkView(species: bloo.species)
                .frame(width: 220, height: 220)

            VStack(alignment: .trailing, spacing: 6) {
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.gray.opacity(0.15))
                        Capsule()
                            .fill(accentColor)
                            .frame(width: proxy.size.width * bloo.stageProgress)
                    }
                }
                .frame(height: 6)

                Text("\(bloo.displayName) is growing 🌱")
                    .font(.bloo(13))
                    .italic()
                    .foregroundStyle(.secondary)
            }
        }
    }
}
