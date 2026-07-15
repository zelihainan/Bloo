//
//  GrowthCardView.swift
//  Bloo
//

import SwiftUI

/// The Bloo's name, its circle portrait, growth progress bar, and the
/// "{name} is growing" caption.
struct GrowthCardView: View {
    let bloo: Bloo

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pose: BlooPose = .idle

    private var accentColor: Color { Color(hex: bloo.species.colorHex) }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                CharacterHabitatView(speciesHex: bloo.species.colorHex)
                if reduceMotion {
                    BlooArtworkView(species: bloo.species, showsBackdrop: false)
                        .frame(width: 190, height: 190)
                } else {
                    PhaseAnimator([false, true]) { phase in
                        BlooArtworkView(species: bloo.species, showsBackdrop: false, pose: pose)
                            .frame(width: 190, height: 190)
                            .scaleEffect(phase ? 1.02 : 1.0)
                    } animation: { _ in
                        .easeInOut(duration: 2.5)
                    }
                    .task(id: bloo.species) {
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
            .id(bloo.species)
            .transition(.opacity)
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.4), value: bloo.species)

            VStack(spacing: 6) {
                ZStack(alignment: .leading) {
                    Capsule().fill(BlooTheme.cardBorder).frame(height: 5)
                    Capsule().fill(accentColor).frame(width: 260 * bloo.stageProgress, height: 5)
                        .animation(reduceMotion ? nil : .easeOut(duration: 0.6), value: bloo.stageProgress)
                }
                .frame(width: 260)

                Text(String(format: NSLocalizedString("%@ is growing 🌱", comment: ""), bloo.displayName))
                    .font(.bloo(11, italic: true))
                    .foregroundStyle(BlooTheme.secondaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(width: 260, alignment: .trailing)
            }
        }
    }
}
