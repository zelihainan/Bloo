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
    let onViewCompleted: (Bloo) -> Void

    private let tileSize: CGFloat = 95
    private let columns: [GridItem]

    init(bloos: [Bloo], onSelect: @escaping (Bloo) -> Void, onViewCompleted: @escaping (Bloo) -> Void) {
        self.bloos = bloos
        self.onSelect = onSelect
        self.onViewCompleted = onViewCompleted
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
        let isCompleted = bloo.state == .completed
        let accent = Color(hex: bloo.species.colorHex)

        return VStack(spacing: 4) {
            Button {
                if isCompleted {
                    onViewCompleted(bloo)
                } else {
                    onSelect(bloo)
                }
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
                            badge(systemImage: "lock.fill")
                        } else if isCompleted {
                            badge(systemImage: "trophy.fill", tint: .white, background: Color(hex: "#FFB020"))
                        }
                    }
            }
            .buttonStyle(.pressable)
            .disabled(isLocked)
            .accessibilityLabel(accessibilityLabel(isActive: isActive, isLocked: isLocked, isCompleted: isCompleted))

            Text(isActive ? LocalizedStringKey("Active companion") : LocalizedStringKey(" "))
                .font(.bloo(9))
                .foregroundStyle(BlooTheme.secondaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(width: tileSize)
    }

    private func accessibilityLabel(isActive: Bool, isLocked: Bool, isCompleted: Bool) -> Text {
        if isLocked { Text("Locked") }
        else if isActive { Text("Active companion") }
        else if isCompleted { Text("Grown up") }
        else { Text("Available") }
    }

    private func badge(systemImage: String, tint: Color = BlooTheme.secondaryText, background: Color = BlooTheme.cardBorder) -> some View {
        ZStack {
            Circle().fill(background).frame(width: 16, height: 16)
            Image(systemName: systemImage)
                .font(.system(size: 8))
                .foregroundStyle(tint)
        }
        .padding(6)
    }
}
