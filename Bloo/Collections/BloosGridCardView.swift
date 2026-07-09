//
//  BloosGridCardView.swift
//  Bloo
//

import SwiftUI

/// "Bloos" card: 3x3 grid of all 9 species. Active gets an accent border +
/// "Active companion" label; locked shows grayscale art; unlocked/completed
/// just show the color art.
struct BloosGridCardView: View {
    let bloos: [Bloo]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)

    private var unlockedCount: Int { bloos.filter { $0.state != .locked }.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Bloos")
                    .font(.bloo(20, weight: .semibold))
                Spacer()
                Text("\(unlockedCount)/\(bloos.count) Unlocked")
                    .font(.bloo(13))
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(bloos.sorted { $0.speciesRawValue < $1.speciesRawValue }) { bloo in
                    tile(for: bloo)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }

    private func tile(for bloo: Bloo) -> some View {
        let isActive = bloo.state == .active
        let isLocked = bloo.state == .locked
        let accent = Color(hex: bloo.species.colorHex)

        return VStack(spacing: 6) {
            BlooArtworkView(species: bloo.species, isLocked: isLocked, showsBackdrop: false)
                .padding(10)
                .aspectRatio(1, contentMode: .fit)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous)
                        .stroke(isActive ? accent : BlooTheme.cardBorder, lineWidth: isActive ? 2 : 1)
                )
                .overlay(alignment: .topTrailing) {
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .font(.bloo(11))
                            .foregroundStyle(.secondary)
                            .padding(6)
                            .background(Color.white)
                            .clipShape(Circle())
                            .padding(6)
                    }
                }

            if isActive {
                Text("Active companion")
                    .font(.bloo(10))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
    }
}
