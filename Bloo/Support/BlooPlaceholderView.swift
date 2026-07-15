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

/// The onboarding egg, with a periodic hatching-anticipation wobble — a quick
/// shake every few seconds rather than a constant shimmy, matching the calm,
/// occasional-not-constant feel of the rest of the app's idle animations.
struct EggArtworkView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var rotation: Double = 0

    var body: some View {
        Image("onboarding_egg")
            .resizable()
            .scaledToFit()
            .rotationEffect(.degrees(rotation))
            .task {
                guard !reduceMotion else { return }
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(.random(in: 2.5...4.5)))
                    guard !Task.isCancelled else { break }
                    await wobble()
                }
            }
    }

    private func wobble() async {
        let steps: [Double] = [-6, 5, -4, 3, -2, 0]
        for angle in steps {
            guard !Task.isCancelled else { return }
            withAnimation(.easeInOut(duration: 0.09)) { rotation = angle }
            try? await Task.sleep(for: .seconds(0.09))
        }
    }
}
