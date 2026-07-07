//
//  Font+Bloo.swift
//  Bloo
//

import SwiftUI

/// Poppins (registered via Info.plist/UIAppFonts, files in Bloo/Fonts) mapped to
/// the same `.system(size:weight:)` call sites already used throughout the app.
extension Font {
    static func bloo(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let name: String = switch weight {
        case .bold, .heavy, .black: "Poppins-Bold"
        case .semibold: "Poppins-SemiBold"
        case .medium: "Poppins-Medium"
        default: "Poppins-Regular"
        }
        return .custom(name, size: size)
    }
}
