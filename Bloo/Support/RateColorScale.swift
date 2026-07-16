import SwiftUI

enum RateColorScale {
    static let noData = Color(hex: "#D9D9D9")

    static func color(forRate rate: Double, accent: Color) -> Color {
        switch rate {
        case 1.0: accent.mixed(withBlack: 0.3)
        case 0.7...: accent
        case 0.0001...: accent.mixed(withWhite: 0.55)
        default: noData
        }
    }
}
