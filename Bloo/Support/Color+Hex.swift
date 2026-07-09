//
//  Color+Hex.swift
//  Bloo
//

import SwiftUI
import UIKit

extension Color {
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255
        let b = Double(rgbValue & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }

    /// A pastel tint of `hex`, blended toward white — used for the backdrop
    /// circle behind a Bloo's portrait. Calibrated against Figma's own
    /// hand-picked pastel for the axolotl (#D4537E -> #FFF0F5 is ~8% mix).
    static func pastel(hex: String, fraction: Double = 0.08) -> Color {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16)
        let g = Double((rgbValue & 0x00FF00) >> 8)
        let b = Double(rgbValue & 0x0000FF)
        func mix(_ channel: Double) -> Double { (255 * (1 - fraction) + channel * fraction) / 255 }
        return Color(red: mix(r), green: mix(g), blue: mix(b))
    }

    /// Blends this color toward white/black — used for the completion-rate color
    /// tiers on Progress (habit activity bars, monthly overview dots), measured
    /// from Figma: 100% = accent mixed ~30% toward black, partial = accent mixed
    /// ~55% toward white.
    func mixed(withWhite fraction: Double) -> Color {
        let (r, g, b) = components
        return Color(red: r + (1 - r) * fraction, green: g + (1 - g) * fraction, blue: b + (1 - b) * fraction)
    }

    func mixed(withBlack fraction: Double) -> Color {
        let (r, g, b) = components
        return Color(red: r * (1 - fraction), green: g * (1 - fraction), blue: b * (1 - fraction))
    }

    private var components: (r: Double, g: Double, b: Double) {
        let uiColor = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b))
    }
}
