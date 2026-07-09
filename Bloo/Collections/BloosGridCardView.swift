//
//  BloosGridCardView.swift
//  Bloo
//
//  Values from the Figma REST API (node 16:15): outer card radius14; tiles are
//  83x78 (radius20) at 10pt column / 17pt row gaps; active tile gets a 1pt
//  accent border + tiny 5px "Active companion" label; locked tiles get a
//  10x10 lock badge near the top-right corner.
//

import SwiftUI

/// "Bloos" card: 3x3 grid of all 9 species. Active gets an accent border +
/// "Active companion" label; locked shows grayscale art; unlocked/completed
/// just show the color art.
struct BloosGridCardView: View {
    let bloos: [Bloo]

    private let columns = [
        GridItem(.fixed(83), spacing: 10),
        GridItem(.fixed(83), spacing: 10),
        GridItem(.fixed(83)),
    ]

    private var unlockedCount: Int { bloos.filter { $0.state != .locked }.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Bloos")
                    .font(.bloo(13, weight: .medium))
                    .foregroundStyle(BlooTheme.secondaryText)
                Spacer()
                Text("\(unlockedCount)/\(bloos.count) Unlocked")
                    .font(.bloo(7))
                    .foregroundStyle(BlooTheme.secondaryText)
            }

            LazyVGrid(columns: columns, spacing: 17) {
                ForEach(bloos.sorted { $0.speciesRawValue < $1.speciesRawValue }) { bloo in
                    tile(for: bloo)
                }
            }
        }
        .padding(13)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }

    private func tile(for bloo: Bloo) -> some View {
        let isActive = bloo.state == .active
        let isLocked = bloo.state == .locked
        let accent = Color(hex: bloo.species.colorHex)

        return VStack(spacing: 4) {
            BlooArtworkView(species: bloo.species, isLocked: isLocked, showsBackdrop: false)
                .padding(8)
                .frame(width: 83, height: 78)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(isActive ? accent : BlooTheme.cardBorder, lineWidth: 1)
                )
                .overlay(alignment: .topTrailing) {
                    if isLocked {
                        ZStack {
                            Circle().fill(BlooTheme.cardBorder).frame(width: 10, height: 10)
                            Image(systemName: "lock.fill")
                                .font(.system(size: 5))
                                .foregroundStyle(BlooTheme.secondaryText)
                        }
                        .padding(6)
                    }
                }

            if isActive {
                Text("Active companion")
                    .font(.bloo(5))
                    .foregroundStyle(BlooTheme.secondaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .frame(width: 83)
    }
}
