//
//  BadgesCardView.swift
//  Bloo
//

import SwiftUI

/// "Badges" card: 4-column grid of all 8 achievements, locked ones grayed with a lock icon.
struct BadgesCardView: View {
    let earnedTypes: Set<BadgeType>

    @Environment(\.blooAccentColor) private var accentColor
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Badges")
                .font(.bloo(20, weight: .semibold))

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(BadgeType.allCases) { type in
                    badgeTile(for: type)
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

    private func badgeTile(for type: BadgeType) -> some View {
        let isEarned = earnedTypes.contains(type)
        return VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isEarned ? accentColor.opacity(0.15) : Color.gray.opacity(0.1))
                    .frame(width: 44, height: 44)
                Image(systemName: isEarned ? type.iconSystemName : "lock.fill")
                    .font(.bloo(16))
                    .foregroundStyle(isEarned ? accentColor : Color.gray.opacity(0.5))
            }
            Text(type.title)
                .font(.bloo(11, weight: .semibold))
                .foregroundStyle(isEarned ? .primary : .secondary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(type.badgeDescription)
                .font(.bloo(9))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 6)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
        .opacity(isEarned ? 1 : 0.7)
    }
}
