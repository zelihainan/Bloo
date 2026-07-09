//
//  Font+Bloo.swift
//  Bloo
//

import SwiftUI

/// Poppins (registered via Info.plist/UIAppFonts, files in Bloo/Fonts) mapped to
/// the same `.system(size:weight:)` call sites already used throughout the app.
extension Font {
    static func bloo(_ size: CGFloat, weight: Font.Weight = .regular, italic: Bool = false) -> Font {
        let base: String = switch weight {
        case .bold, .heavy, .black: "Bold"
        case .semibold: "SemiBold"
        case .medium: "Medium"
        case .light, .ultraLight, .thin: "Light"
        default: "Regular"
        }
        let name: String
        if italic {
            name = base == "Regular" ? "Poppins-Italic" : "Poppins-\(base)Italic"
        } else {
            name = "Poppins-\(base)"
        }
        return .custom(name, size: size)
    }
}
