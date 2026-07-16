import SwiftUI

struct HomeHeaderView: View {
    let greeting: String
    let subtitle: String
    let dayNumber: Int
    let accentColor: Color

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 0) {
                Text(LocalizedStringKey(greeting))
                    .font(.bloo(22, weight: .medium))
                    .foregroundStyle(BlooTheme.primaryText)
                Text(LocalizedStringKey(subtitle))
                    .font(.bloo(13))
                    .foregroundStyle(BlooTheme.secondaryText)
            }
            .padding(.leading, 8)

            Text(String(format: NSLocalizedString("Day %d", comment: ""), dayNumber))
                .font(.bloo(12, weight: .medium))
                .foregroundStyle(BlooTheme.tertiaryText)
                .frame(width: 62, height: 24)
                .background(accentColor.opacity(0.1))
                .clipShape(Capsule())
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
