//
//  RateColorScale.swift
//  Bloo
//
//  The 4-tier completion-rate color scheme shared by the habit-activity bars
//  and the monthly-overview dots, measured from Figma's Progress screen:
//  100% = accent mixed ~30% toward black (#D4537E -> #993556), ~70-99% =
//  accent as-is, partial = accent mixed ~55% toward white (#D4537E -> #F4A7C3),
//  0%/no data = a fixed neutral (#D9D9D9).
//

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
