//
//  BlooTheme.swift
//  Bloo
//

import SwiftUI

/// Static design tokens shared by every screen.
enum BlooTheme {
    static let background = Color(hex: "#FAFAF8")
    static let cardBorder = Color(hex: "#F0EDE8")
    static let primaryButtonBackground = Color(hex: "#1A1A1A")
    static let cardCornerRadius: CGFloat = 16
    static let buttonCornerRadius: CGFloat = 16
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
