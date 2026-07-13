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
        let fallDuration: Double
        let rotationSpeed: Double
        let color: Color
        let size: CGFloat
        let wobbleAmplitude: CGFloat
        let wobbleFrequency: Double
        let wobblePhase: Double
    }

    private let particles: [Particle]
    private let startDate = Date()
    /// Longest any single particle can still be visible for — callers should
    /// keep this view alive at least this long before removing it.
    static let totalDuration: Double = 3.6

    init(colors: [Color], particleCount: Int = 32) {
        self.colors = colors
        self.particles = (0..<particleCount).map { _ in
            Particle(
                xFraction: .random(in: 0...1),
                delay: .random(in: 0...0.5),
                fallDuration: .random(in: 1.8...3.0),
                rotationSpeed: .random(in: 140...460),
                color: colors.randomElement() ?? .pink,
                size: .random(in: 5...10),
                wobbleAmplitude: .random(in: 12...36),
                wobbleFrequency: .random(in: 1.2...2.6),
                wobblePhase: .random(in: 0...(2 * .pi))
            )
        }
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let elapsed = timeline.date.timeIntervalSince(startDate)
                for particle in particles {
                    let t = (elapsed - particle.delay) / particle.fallDuration
                    guard t > 0, t < 1.05 else { continue }
                    let clampedT = min(t, 1)
                    // Ease-in fall (gravity-like acceleration) instead of a uniform linear drop.
                    let fallT = clampedT * clampedT
                    let wobble = sin(elapsed * particle.wobbleFrequency + particle.wobblePhase) * particle.wobbleAmplitude
                    let x = particle.xFraction * size.width + wobble
                    let y = fallT * (size.height + 40) - 20
                    let opacity = clampedT > 0.75 ? max(0, (1 - clampedT) / 0.25) : 1

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
