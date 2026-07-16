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
