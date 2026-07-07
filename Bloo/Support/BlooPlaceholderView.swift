//
//  BlooPlaceholderView.swift
//  Bloo
//

import SwiftUI

/// Stand-in artwork until the final character illustrations are dropped into
/// Assets.xcassets — a colored circle in the species' theme color with a simple
/// glyph. Swap this out for `Image(species.assetName)` once real art lands.
struct BlooPlaceholderView: View {
    let species: BlooSpecies
    var isLocked: Bool = false

    var body: some View {
        let color = Color(hex: species.colorHex)
        ZStack {
            Circle()
                .fill(isLocked ? Color.gray.opacity(0.12) : color.opacity(0.18))
            Image(systemName: isLocked ? "lock.fill" : "pawprint.fill")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(isLocked ? Color.gray.opacity(0.45) : color)
        }
    }
}

/// Stand-in artwork for the onboarding egg.
struct EggPlaceholderView: View {
    var body: some View {
        let color = Color(hex: "#E8845A")
        ZStack {
            Circle().fill(color.opacity(0.15))
            Image(systemName: "sparkles")
                .font(.system(size: 44, weight: .medium))
                .foregroundStyle(color)
        }
    }
}
