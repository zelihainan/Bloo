//
//  BlooPlaceholderView.swift
//  Bloo
//

import SwiftUI

/// An alternate pose for a Bloo's illustration — only some species currently
/// have dedicated art for this (checked at runtime), falls back to `.idle`.
enum BlooPose: String {
    case idle
    case blink
}

/// Renders a Bloo's real illustration (`bloo_1`...`bloo_9` in Assets.xcassets).
/// When locked, uses the dedicated grayscale `_locked` art if one was provided
/// (currently species 6-9), otherwise desaturates + dims the color art instead.
struct BlooArtworkView: View {
    let species: BlooSpecies
    var isLocked: Bool = false
    var showsBackdrop: Bool = true
    var pose: BlooPose = .idle

    private var color: Color { Color(hex: species.colorHex) }
    private var lockedAssetName: String { "\(species.assetName)_locked" }
    private var hasDedicatedLockedArt: Bool { UIImage(named: lockedAssetName) != nil }

    private func assetName(for pose: BlooPose) -> String { "\(species.assetName)_\(pose.rawValue)" }
    private func hasArt(for pose: BlooPose) -> Bool { UIImage(named: assetName(for: pose)) != nil }

    var body: some View {
        ZStack {
            if showsBackdrop {
                Circle().fill(isLocked ? Color.gray.opacity(0.12) : color.opacity(0.18))
            }
            artwork
                .padding(showsBackdrop ? 8 : 0)
        }
    }

    @ViewBuilder
    private var artwork: some View {
        if isLocked && hasDedicatedLockedArt {
            Image(lockedAssetName).resizable().scaledToFit()
        } else if isLocked {
            Image(species.assetName)
                .resizable()
                .scaledToFit()
                .saturation(0)
                .opacity(0.5)
        } else {
            // Both poses stay mounted simultaneously and only crossfade via opacity —
            // swapping an Image's underlying asset isn't itself animatable, and
            // inserting/removing a fresh Image each time briefly shows nothing while
            // the (large) replacement PNG decodes, reading as a white flash.
            ZStack {
                Image(species.assetName)
                    .resizable()
                    .scaledToFit()
                    .opacity(pose == .idle ? 1 : 0)
                if hasArt(for: .blink) {
                    Image(assetName(for: .blink))
                        .resizable()
                        .scaledToFit()
                        .opacity(pose == .blink ? 1 : 0)
                }
            }
        }
    }
}

/// The onboarding egg, with a frequent hatching-anticipation wobble and a
/// burst of gold sparkles each time it shakes — something inside is clearly
/// trying to get out.
struct EggArtworkView: View {
    var size: CGFloat = 220

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var rotation: Double = 0
    @State private var sparkleBurst = false

    private let gold = Color(hex: "#FFB020")

    var body: some View {
        ZStack {
            sparkle(dx: -0.36, dy: -0.32, symbolSize: 15, symbol: "sparkle")
            sparkle(dx: 0.38, dy: -0.20, symbolSize: 11, symbol: "star.fill")
            sparkle(dx: -0.30, dy: 0.18, symbolSize: 9, symbol: "star.fill")
            sparkle(dx: 0.34, dy: 0.24, symbolSize: 13, symbol: "sparkle")
            sparkle(dx: 0.02, dy: -0.44, symbolSize: 10, symbol: "star.fill")

            Image("onboarding_egg")
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(rotation))
        }
        .frame(width: size, height: size)
        .task {
            guard !reduceMotion else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(.random(in: 1.0...1.8)))
                guard !Task.isCancelled else { break }
                await wobble()
            }
        }
    }

    private func sparkle(dx: CGFloat, dy: CGFloat, symbolSize: CGFloat, symbol: String) -> some View {
        Image(systemName: symbol)
            .font(.system(size: symbolSize))
            .foregroundStyle(gold)
            .scaleEffect(sparkleBurst ? 1 : 0.2)
            .opacity(sparkleBurst ? 0.95 : 0)
            .offset(x: size * dx, y: size * dy)
    }

    private func wobble() async {
        withAnimation(.easeOut(duration: 0.16)) { sparkleBurst = true }

        let steps: [Double] = [-7, 6, -5, 4, -3, 2, 0]
        for angle in steps {
            guard !Task.isCancelled else { return }
            withAnimation(.easeInOut(duration: 0.08)) { rotation = angle }
            try? await Task.sleep(for: .seconds(0.08))
        }

        guard !Task.isCancelled else { return }
        withAnimation(.easeIn(duration: 0.45)) { sparkleBurst = false }
    }
}
