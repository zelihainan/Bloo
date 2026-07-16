import SwiftUI

struct BadgesCardView: View {
    let earnedTypes: Set<BadgeType>

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 4)

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text("Badges")
                .font(.bloo(16, weight: .medium))
                .foregroundStyle(BlooTheme.secondaryText)

            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(BadgeType.allCases) { type in
                    badgeTile(for: type)
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

    private func badgeTile(for type: BadgeType) -> some View {
        let isEarned = earnedTypes.contains(type)
        return VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(isEarned ? Color(hex: type.circleColorHex) : Color.gray.opacity(0.12))
                    .frame(width: 34, height: 34)
                if isEarned {
                    Text(type.emoji).font(.system(size: 17))
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.gray.opacity(0.5))
                }
            }
            Text(LocalizedStringKey(type.title))
                .font(.bloo(10, weight: .medium))
                .foregroundStyle(BlooTheme.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(LocalizedStringKey(type.badgeDescription))
                .font(.bloo(8, weight: .medium))
                .foregroundStyle(BlooTheme.tertiaryText)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.75)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .padding(.vertical, 10)
        .padding(.horizontal, 4)
        .background(isEarned ? Color.white : Color(hex: "#F5F5F5"))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }
}
