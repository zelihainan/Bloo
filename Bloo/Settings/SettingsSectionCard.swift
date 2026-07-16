import SwiftUI

struct SettingsSectionCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStringKey(title))
                .font(.bloo(15, weight: .medium))
                .foregroundStyle(BlooTheme.secondaryText)
                .padding(.horizontal, 4)

            VStack(spacing: 0) { content }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous)
                        .stroke(BlooTheme.cardBorder, lineWidth: 1)
                )
        }
    }
}
