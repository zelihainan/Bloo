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
    @State private var waveRotation: Double = 0

    private var accentColor: Color { Color(hex: bloo.species.colorHex) }
    private var backdropColor: Color { Color.pastel(hex: bloo.species.colorHex) }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(backdropColor)
                    .frame(width: 219, height: 219)
                if reduceMotion {
                    BlooArtworkView(species: bloo.species, showsBackdrop: false)
                        .frame(width: 190, height: 190)
                } else {
                    PhaseAnimator([false, true]) { phase in
                        BlooArtworkView(species: bloo.species, showsBackdrop: false, pose: pose)
                            .frame(width: 190, height: 190)
                            .scaleEffect(phase ? 1.02 : 1.0)
                            .rotationEffect(.degrees(waveRotation), anchor: .bottom)
                    } animation: { _ in
                        .easeInOut(duration: 2.5)
                    }
                    .task(id: bloo.species) {
                        // Greet once with a wave, then blink periodically for the rest of the visit.
                        // Each pose change is wrapped in its own crossfade so the artwork swap
                        // fades smoothly instead of popping instantly.
                        try? await Task.sleep(for: .seconds(0.6))
                        withAnimation(.easeInOut(duration: 0.5)) { pose = .wave }
                        // A little side-to-side rock while the paw is up sells the "wave"
                        // gesture — a single static frame alone reads as a stiff pop.
                        waveRotation = -4
                        withAnimation(.easeInOut(duration: 0.22).repeatCount(6, autoreverses: true)) {
                            waveRotation = 4
                        }
                        try? await Task.sleep(for: .seconds(2.2))
                        withAnimation(.easeInOut(duration: 0.3)) { waveRotation = 0 }
                        withAnimation(.easeInOut(duration: 0.5)) { pose = .idle }

                        while !Task.isCancelled {
                            try? await Task.sleep(for: .seconds(.random(in: 3...6)))
                            withAnimation(.easeInOut(duration: 0.35)) { pose = .blink }
                            try? await Task.sleep(for: .seconds(0.5))
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
