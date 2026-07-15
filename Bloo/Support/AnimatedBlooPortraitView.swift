//
//  AnimatedBlooPortraitView.swift
//  Bloo
//
//  A Bloo's portrait with its idle "alive" animation — a slow breathing scale
//  plus a periodic blink — shared by Home's growth card and the onboarding
//  naming screen so a Bloo feels the same everywhere it's shown at full size.
//

import SwiftUI

struct AnimatedBlooPortraitView: View {
    let species: BlooSpecies
    var size: CGFloat = 190

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pose: BlooPose = .idle

    var body: some View {
        Group {
            if reduceMotion {
                BlooArtworkView(species: species, showsBackdrop: false)
            } else {
                PhaseAnimator([false, true]) { phase in
                    BlooArtworkView(species: species, showsBackdrop: false, pose: pose)
                        .scaleEffect(phase ? 1.02 : 1.0)
                } animation: { _ in
                    .easeInOut(duration: 2.5)
                }
                .task(id: species) {
                    // Blink periodically for as long as this Bloo is shown. Cancellation
                    // is checked explicitly after every sleep — `try?` alone swallows the
                    // cancellation error and would let a stale, superseded task instance
                    // keep mutating `pose` after a fresh one has already started.
                    pose = .idle

                    while !Task.isCancelled {
                        try? await Task.sleep(for: .seconds(.random(in: 3...6)))
                        guard !Task.isCancelled else { break }
                        withAnimation(.easeInOut(duration: 0.35)) { pose = .blink }

                        try? await Task.sleep(for: .seconds(0.5))
                        guard !Task.isCancelled else { break }
                        withAnimation(.easeInOut(duration: 0.35)) { pose = .idle }
                    }
                }
            }
        }
        .frame(width: size, height: size)
    }
}
