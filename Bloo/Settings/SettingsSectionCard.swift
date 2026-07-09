//
//  SettingsSectionCard.swift
//  Bloo
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
                .font(.bloo(14, weight: .medium))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)

            VStack(spacing: 0) { content }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous)
                        .stroke(BlooTheme.cardBorder, lineWidth: 1)
                )
        }
    }
}
