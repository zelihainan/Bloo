//
//  SettingsSectionCard.swift
//  Bloo
//
//  Section label is 13px medium #8A8278; card radius14 (Figma node 17:118).
//

import SwiftUI

/// A titled white card grouping a set of `SettingsRow`s, matching the Habits /
/// Notifications / Data / About sections on the Settings screen.
struct SettingsSectionCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
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
