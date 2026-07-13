//
//  ConfettiView.swift
//  Bloo
//
//  One-off, non-looping confetti burst for celebratory moments (e.g. a new
//  Bloo unlocking). The parent is responsible for adding/removing this view
//  from the hierarchy — it does not loop or restart on its own.
//

import SwiftUI

struct ConfettiView: View {
    let colors: [Color]

    private struct Particle {
        let xFraction: CGFloat
        let delay: Double
        let rotationSpeed: Double
        let color: Color
        let size: CGFloat
        let horizontalDrift: CGFloat
    }

    private let particles: [Particle]
    private let startDate = Date()
    private let duration: Double = 1.6

    init(colors: [Color], particleCount: Int = 26) {
        self.colors = colors
        self.particles = (0..<particleCount).map { _ in
            Particle(
                xFraction: .random(in: 0...1),
                delay: .random(in: 0...0.3),
                rotationSpeed: .random(in: 180...540),
                color: colors.randomElement() ?? .pink,
                size: .random(in: 5...9),
                horizontalDrift: .random(in: -50...50)
            )
        }
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let elapsed = timeline.date.timeIntervalSince(startDate)
                for particle in particles {
                    let localDuration = duration - particle.delay
                    let t = (elapsed - particle.delay) / localDuration
                    guard t > 0, t < 1.05 else { continue }
                    let clampedT = min(t, 1)
                    let x = particle.xFraction * size.width + particle.horizontalDrift * clampedT
                    let y = clampedT * (size.height + 40) - 20
                    let opacity = clampedT > 0.7 ? max(0, (1 - clampedT) / 0.3) : 1

                    var ctx = context
                    ctx.opacity = opacity
                    ctx.translateBy(x: x, y: y)
                    ctx.rotate(by: .degrees(particle.rotationSpeed * elapsed))
                    let rect = CGRect(x: -particle.size / 2, y: -particle.size / 2, width: particle.size, height: particle.size * 0.6)
                    ctx.fill(Path(roundedRect: rect, cornerRadius: 1.5), with: .color(particle.color))
                }
            }
        }
        .allowsHitTesting(false)
    }
}
