import SwiftUI

extension Font {
    static func bloo(_ size: CGFloat, weight: Font.Weight = .regular, italic: Bool = false) -> Font {
        let base: String = switch weight {
        case .bold, .heavy, .black: "Bold"
        case .semibold: "SemiBold"
        case .medium: "Medium"
        case .light, .ultraLight, .thin: "Light"
        default: "Regular"
        }
        let name = italic ? "Poppins-LightItalic" : "Poppins-\(base)"
        return .custom(name, size: size)
    }
}
