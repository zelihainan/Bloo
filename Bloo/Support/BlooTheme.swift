//
//  BlooTheme.swift
//  Bloo
//

import SwiftUI

/// Static design tokens shared by every screen. Colors marked "Figma" are
/// taken directly from the Figma file's dev-mode inspector, not estimated.
enum BlooTheme {
    static let background = Color(hex: "#FAFAF8")
    static let cardBorder = Color(hex: "#F0EDE8")
    static let primaryButtonBackground = Color(hex: "#1A1A1A")
    static let cardCornerRadius: CGFloat = 20
    static let buttonCornerRadius: CGFloat = 16

    /// Primary text/label color (Figma "Labels - Vibrant/Primary").
    static let primaryText = Color(hex: "#1A1A1A")
    /// Secondary/caption text color (subtitle, "is growing" caption, ...).
    static let secondaryText = Color(hex: "#8A8278")
    /// Even lighter secondary text (the "Day N" badge label).
    static let tertiaryText = Color(hex: "#B0A898")
    /// Checkbox border color.
    static let checkboxBorder = Color(hex: "#E0DDD8")
    /// Tab bar top divider line.
    static let tabBarDivider = Color(hex: "#E2E2E2")
    /// Tab bar icon color (Figma "icon-default-default" — same for active/inactive; only the dot changes).
    static let tabIcon = Color(hex: "#1E1E1E")

    /// Fixed semantic colors on Progress (not tied to the active species) —
    /// "Best habit" and "Needs attention" use these regardless of accent.
    static let successColor = Color(hex: "#5DCAA5")
    static let warningColor = Color(hex: "#E8845A")
}

/// The active Bloo's species color, used for selection borders, progress bars,
/// and other accents. Buttons stay black regardless (see `BlooTheme`).
private struct BlooAccentColorKey: EnvironmentKey {
    static let defaultValue: Color = BlooTheme.primaryButtonBackground
}

extension EnvironmentValues {
    var blooAccentColor: Color {
        get { self[BlooAccentColorKey.self] }
        set { self[BlooAccentColorKey.self] = newValue }
    }
}
