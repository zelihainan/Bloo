import SwiftUI

struct BadgeUnlockToastView: View {
    let badge: BadgeType

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(hex: badge.circleColorHex))
                    .frame(width: 44, height: 44)
                Text(badge.emoji)
                    .font(.system(size: 22))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("New badge unlocked!")
                    .font(.bloo(11, weight: .semibold))
                    .foregroundStyle(BlooTheme.tertiaryText)
                Text(LocalizedStringKey(badge.title))
                    .font(.bloo(15, weight: .semibold))
                    .foregroundStyle(BlooTheme.primaryText)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
        .overlay {
            if !reduceMotion {
                ConfettiView(colors: [Color(hex: badge.circleColorHex), .yellow, .white])
                    .allowsHitTesting(false)
            }
        }
    }
}
