//
//  PrimaryButtonStyle.swift
//  Bloo
//

import SwiftUI

/// The filled capsule button used for every primary action (Get started /
/// Continue / Save Habit) across the app — same look everywhere: solid
/// `BlooTheme.secondaryText` (#8A8278) fill, white Poppins SemiBold text.
struct PrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.bloo(15, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(BlooTheme.secondaryText.opacity(isEnabled ? 1 : 0.4))
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static func bloo(isEnabled: Bool = true) -> PrimaryButtonStyle { PrimaryButtonStyle(isEnabled: isEnabled) }
}

/// The white, bordered capsule button for secondary/destructive actions
/// (Delete Habit) — same treatment everywhere: white fill, `secondaryText`
/// stroke and label.
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.bloo(15))
            .foregroundStyle(BlooTheme.secondaryText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.white)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(BlooTheme.secondaryText, lineWidth: 0.5))
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var blooSecondary: SecondaryButtonStyle { SecondaryButtonStyle() }
}

/// The white, bordered, rounded field/card look shared by text fields, note boxes, and rows.
struct BlooFieldBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous)
                    .stroke(BlooTheme.cardBorder, lineWidth: 1)
            )
    }
}

extension View {
    func blooFieldBackground() -> some View { modifier(BlooFieldBackground()) }
}
