//
//  PrimaryButtonStyle.swift
//  Bloo
//

import SwiftUI

/// The black, full-width, rounded button used for every primary action
/// (Get started / Continue / Save Habit) across the app.
struct PrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(BlooTheme.primaryButtonBackground.opacity(isEnabled ? 1 : 0.35))
            .clipShape(RoundedRectangle(cornerRadius: BlooTheme.buttonCornerRadius, style: .continuous))
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static func bloo(isEnabled: Bool = true) -> PrimaryButtonStyle { PrimaryButtonStyle(isEnabled: isEnabled) }
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
