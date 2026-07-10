//
//  HomeHeaderView.swift
//  Bloo
//
//  Pixel values from Figma dev-mode (node 5:109): title 22px Medium, subtitle
//  13px Regular #8A8278, day badge 54x21 pill at accentColor 10% opacity with
//  10px Medium #B0A898 text.
//

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
                .font(.bloo(10, weight: .medium))
                .foregroundStyle(BlooTheme.tertiaryText)
                .frame(width: 54, height: 21)
                .background(accentColor.opacity(0.1))
                .clipShape(Capsule())
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
