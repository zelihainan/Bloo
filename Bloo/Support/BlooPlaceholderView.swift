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

/// The onboarding egg, with a frequent hatching-anticipation wobble and gold
/// sparkles/stars that twinkle continuously and independently around it —
/// something inside is clearly trying to get out, non-stop.
struct EggArtworkView: View {
    var size: CGFloat = 220

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var rotation: Double = 0

    private struct SparkleSpec {
        let dx: CGFloat
        let dy: CGFloat
        let symbolSize: CGFloat
        let symbol: String
        let duration: Double
        let delay: Double
    }

    private let sparkles: [SparkleSpec] = [
        .init(dx: -0.40, dy: -0.34, symbolSize: 14, symbol: "sparkle", duration: 0.7, delay: 0.0),
        .init(dx: 0.40, dy: -0.22, symbolSize: 11, symbol: "star.fill", duration: 0.9, delay: 0.15),
        .init(dx: -0.32, dy: 0.18, symbolSize: 9, symbol: "star.fill", duration: 0.65, delay: 0.35),
        .init(dx: 0.36, dy: 0.26, symbolSize: 13, symbol: "sparkle", duration: 0.85, delay: 0.05),
        .init(dx: 0.04, dy: -0.46, symbolSize: 10, symbol: "star.fill", duration: 0.75, delay: 0.25),
        .init(dx: -0.10, dy: 0.42, symbolSize: 8, symbol: "sparkle", duration: 0.8, delay: 0.45),
        .init(dx: -0.44, dy: 0.02, symbolSize: 9, symbol: "star.fill", duration: 0.7, delay: 0.55),
    ]

    var body: some View {
        ZStack {
            ForEach(Array(sparkles.enumerated()), id: \.offset) { _, spec in
                TwinklingSparkle(
                    dx: spec.dx, dy: spec.dy,
                    symbolSize: spec.symbolSize, symbol: spec.symbol,
                    containerSize: size,
                    duration: spec.duration, delay: spec.delay,
                    reduceMotion: reduceMotion
                )
            }

            Image("onboarding_egg")
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(rotation))
        }
        .frame(width: size, height: size)
        .task {
            guard !reduceMotion else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(.random(in: 0.5...0.9)))
                guard !Task.isCancelled else { break }
                await wobble()
            }
        }
    }

    private func wobble() async {
        let steps: [Double] = [-7, 6, -5, 4, -3, 2, 0]
        for angle in steps {
            guard !Task.isCancelled else { return }
            withAnimation(.easeInOut(duration: 0.07)) { rotation = angle }
            try? await Task.sleep(for: .seconds(0.07))
        }
    }
}

/// A single gold spark that twinkles on its own continuous, staggered loop —
/// never fully pausing, independent of the egg's wobble.
private struct TwinklingSparkle: View {
    let dx: CGFloat
    let dy: CGFloat
    let symbolSize: CGFloat
    let symbol: String
    let containerSize: CGFloat
    let duration: Double
    let delay: Double
    let reduceMotion: Bool

    @State private var twinkle = false

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: symbolSize))
            .foregroundStyle(Color(hex: "#FFB020"))
            .scaleEffect(twinkle ? 1 : 0.35)
            .opacity(twinkle ? 1 : 0.25)
            .offset(x: containerSize * dx, y: containerSize * dy)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true).delay(delay)) {
                    twinkle = true
                }
            }
    }
}
