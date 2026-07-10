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
        // Only a Light-weight italic face is bundled (see Info.plist's UIAppFonts) —
        // other weight+italic combinations don't exist as real font files and would
        // silently fall back to the system font, so italic always uses that one face.
        let name = italic ? "Poppins-LightItalic" : "Poppins-\(base)"
        return .custom(name, size: size)
    }
}
