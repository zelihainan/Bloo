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
