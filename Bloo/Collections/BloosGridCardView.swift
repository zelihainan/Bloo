//
//  BloosGridCardView.swift
//  Bloo
//
//  3x3 grid of all 9 species. Active gets an accent border + "Active companion"
//  label; locked shows grayscale art with a lock badge; unlocked (not active,
//  not completed) tiles are tappable to become the new active companion.
//

import SwiftUI

struct BloosGridCardView: View {
    let bloos: [Bloo]
    let onSelect: (Bloo) -> Void

    private let tileSize: CGFloat = 95
    private let columns: [GridItem]

    init(bloos: [Bloo], onSelect: @escaping (Bloo) -> Void) {
        self.bloos = bloos
        self.onSelect = onSelect
        self.columns = [
            GridItem(.fixed(95), spacing: 12),
            GridItem(.fixed(95), spacing: 12),
            GridItem(.fixed(95)),
        ]
    }

    private var unlockedCount: Int { bloos.filter { $0.state != .locked }.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Bloos")
                    .font(.bloo(16, weight: .medium))
                    .foregroundStyle(BlooTheme.secondaryText)
                Spacer()
                Text(String(format: NSLocalizedString("%d/%d Unlocked", comment: ""), unlockedCount, bloos.count))
                    .font(.bloo(11))
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
        let isSelectable = !isLocked
        let accent = Color(hex: bloo.species.colorHex)

        return VStack(spacing: 4) {
            Button {
                onSelect(bloo)
            } label: {
                BlooArtworkView(species: bloo.species, isLocked: isLocked, showsBackdrop: false)
                    .padding(10)
                    .frame(width: tileSize, height: tileSize)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(isActive ? accent : BlooTheme.cardBorder, lineWidth: isActive ? 2 : 1)
                    )
                    .overlay(alignment: .topTrailing) {
                        if isLocked {
                            ZStack {
                                Circle().fill(BlooTheme.cardBorder).frame(width: 16, height: 16)
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 8))
                                    .foregroundStyle(BlooTheme.secondaryText)
                            }
                            .padding(6)
                        }
                    }
            }
            .buttonStyle(.plain)
            .disabled(!isSelectable)

            Text(isActive ? LocalizedStringKey("Active companion") : LocalizedStringKey(" "))
                .font(.bloo(9))
                .foregroundStyle(BlooTheme.secondaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(width: tileSize)
    }
}
