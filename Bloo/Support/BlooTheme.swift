import SwiftUI

enum BlooTheme {
    static let background = Color(hex: "#FAFAF8")
    static let cardBorder = Color(hex: "#F0EDE8")
    static let primaryButtonBackground = Color(hex: "#1A1A1A")
    static let cardCornerRadius: CGFloat = 20
    static let secondaryCardCornerRadius: CGFloat = 14
    static let buttonCornerRadius: CGFloat = 16

    static let primaryText = Color(hex: "#1A1A1A")
    static let secondaryText = Color(hex: "#8A8278")
    static let tertiaryText = Color(hex: "#B0A898")
    static let checkboxBorder = Color(hex: "#E0DDD8")
    static let tabBarDivider = Color(hex: "#E2E2E2")
    static let tabIcon = Color(hex: "#1E1E1E")

    static let successColor = Color(hex: "#5DCAA5")
    static let warningColor = Color(hex: "#E8845A")
}

private struct BlooAccentColorKey: EnvironmentKey {
    static let defaultValue: Color = BlooTheme.primaryButtonBackground
}

extension EnvironmentValues {
    var blooAccentColor: Color {
        get { self[BlooAccentColorKey.self] }
        set { self[BlooAccentColorKey.self] = newValue }
    }
}
