//
//  CharacterHabitatView.swift
//  Bloo
//
//  A wide, landscape "mini scene" behind a Bloo's portrait: a vivid sky
//  gradient, layered hills for depth, drifting clouds, a continuous grass
//  strip spanning the full width (so every species reads as standing on
//  solid ground regardless of exactly where its feet land in its own
//  artwork), a soft contact shadow for grounding, and a sprinkle of rocks,
//  flowers, plants, leaves and sparkles. Purely a decorative backdrop — the
//  caller layers the character portrait on top, unchanged in position or size.
//

import SwiftUI

struct CharacterHabitatView: View {
    var speciesHex: String
    var height: CGFloat = 210

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animate = false

    private var skyTop: Color { Color.pastel(hex: "#4FA3F0", fraction: 0.55) }
    private var skyBottom: Color { Color.pastel(hex: speciesHex, fraction: 0.28) }
    private var farHillColor: Color { Color.pastel(hex: "#3FA36A", fraction: 0.55) }
    private var nearHillColor: Color { Color.pastel(hex: "#2F9158", fraction: 0.68) }
    private var grassTop: Color { Color(hex: "#7ED28C") }
    private var grassBottom: Color { Color(hex: "#48A25E") }

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                LinearGradient(colors: [skyTop, skyBottom], startPoint: .top, endPoint: .bottom)
                sunGlow(w: w, h: h)
                farHills(w: w, h: h)
                nearHills(w: w, h: h)
                clouds(w: w, h: h)
                sparkles(w: w, h: h)
                leaves(w: w, h: h)
                groundShadow(w: w, h: h)
                ground(w: w, h: h)
                decor(w: w, h: h)
            }
            .clipShape(RoundedRectangle(cornerRadius: h * 0.24, style: .continuous))
        }
        .frame(height: height)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }

    // MARK: - Sky

    private func sunGlow(w: CGFloat, h: CGFloat) -> some View {
        RadialGradient(colors: [Color.white.opacity(0.55), Color.white.opacity(0)], center: .center, startRadius: 0, endRadius: w * 0.22)
            .frame(width: w * 0.44, height: w * 0.44)
            .position(x: w * 0.82, y: h * 0.16)
    }

    private func farHills(w: CGFloat, h: CGFloat) -> some View {
        wave(w: w, baseline: h * 0.60, amplitude: h * 0.05, phase: 0)
            .fill(farHillColor.opacity(0.45))
    }

    private func nearHills(w: CGFloat, h: CGFloat) -> some View {
        wave(w: w, baseline: h * 0.66, amplitude: h * 0.06, phase: 0.4)
            .fill(nearHillColor.opacity(0.4))
    }

    /// A gentle, organic hill/ground silhouette spanning the full width —
    /// deliberately wavy rather than a hard horizontal line so it reads as
    /// terrain, not a ruler-straight cutoff.
    private func wave(w: CGFloat, baseline: CGFloat, amplitude: CGFloat, phase: CGFloat) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: baseline + amplitude * 0.4))
            path.addCurve(
                to: CGPoint(x: w * 0.5, y: baseline - amplitude * (0.6 + phase * 0.3)),
                control1: CGPoint(x: w * 0.18, y: baseline + amplitude),
                control2: CGPoint(x: w * 0.32, y: baseline - amplitude)
            )
            path.addCurve(
                to: CGPoint(x: w, y: baseline + amplitude * 0.3),
                control1: CGPoint(x: w * 0.68, y: baseline - amplitude * (0.9 - phase * 0.3)),
                control2: CGPoint(x: w * 0.85, y: baseline + amplitude)
            )
            // Extend well past any container height — this is only ever
            // clipped by the rounded-rect mask, so it just needs to fully
            // cover the bottom regardless of the baseline/amplitude passed in.
            path.addLine(to: CGPoint(x: w, y: baseline + 1000))
            path.addLine(to: CGPoint(x: 0, y: baseline + 1000))
            path.closeSubpath()
        }
    }

    private func clouds(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            cloud(x: w * 0.16, y: h * 0.16, symbolSize: 20, drift: 6)
            cloud(x: w * 0.80, y: h * 0.30, symbolSize: 13, drift: -5)
        }
    }

    private func cloud(x: CGFloat, y: CGFloat, symbolSize: CGFloat, drift: CGFloat) -> some View {
        Image(systemName: "cloud.fill")
            .font(.system(size: symbolSize))
            .foregroundStyle(Color.white.opacity(0.9))
            .position(x: x + (animate ? drift : -drift), y: y)
    }

    private func sparkles(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            sparkle(x: w * 0.90, y: h * 0.42, symbolSize: 9)
            sparkle(x: w * 0.08, y: h * 0.50, symbolSize: 7)
        }
    }

    private func sparkle(x: CGFloat, y: CGFloat, symbolSize: CGFloat) -> some View {
        Image(systemName: "sparkle")
            .font(.system(size: symbolSize))
            .foregroundStyle(Color.white.opacity(animate ? 0.9 : 0.35))
            .position(x: x, y: y)
    }

    private func leaves(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            leaf(x: w * 0.10, y: h * 0.26, rotation: -20, tint: farHillColor)
            leaf(x: w * 0.92, y: h * 0.50, rotation: 25, tint: nearHillColor)
        }
    }

    private func leaf(x: CGFloat, y: CGFloat, rotation: Double, tint: Color) -> some View {
        Image(systemName: "leaf.fill")
            .font(.system(size: 10))
            .foregroundStyle(tint.opacity(0.8))
            .rotationEffect(.degrees(rotation + (animate ? 10 : -10)))
            .position(x: x, y: y + (animate ? -4 : 4))
    }

    // MARK: - Ground

    private func groundShadow(w: CGFloat, h: CGFloat) -> some View {
        Ellipse()
            .fill(Color.black.opacity(0.16))
            .frame(width: w * 0.30, height: h * 0.06)
            .blur(radius: 5)
            .position(x: w * 0.5, y: h * 0.75)
    }

    private func ground(w: CGFloat, h: CGFloat) -> some View {
        wave(w: w, baseline: h * 0.74, amplitude: h * 0.035, phase: 0.2)
            .fill(LinearGradient(colors: [grassTop, grassBottom], startPoint: .top, endPoint: .bottom))
    }

    private func decor(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            rock(x: w * 0.18, y: h * 0.86, diameter: 11)
            rock(x: w * 0.85, y: h * 0.90, diameter: 8)

            flower(x: w * 0.10, y: h * 0.82, tint: .pink)
            flower(x: w * 0.73, y: h * 0.94, tint: .yellow)

            plant(x: w * 0.90, y: h * 0.80)
            plant(x: w * 0.30, y: h * 0.94)
        }
    }

    private func rock(x: CGFloat, y: CGFloat, diameter: CGFloat) -> some View {
        Circle()
            .fill(Color(hex: "#B7AFA1"))
            .frame(width: diameter, height: diameter * 0.8)
            .position(x: x, y: y)
    }

    private func plant(x: CGFloat, y: CGFloat) -> some View {
        Image(systemName: "leaf.fill")
            .font(.system(size: 9))
            .foregroundStyle(grassBottom)
            .rotationEffect(.degrees(-20))
            .position(x: x, y: y)
    }

    private func flower(x: CGFloat, y: CGFloat, tint: Color) -> some View {
        ZStack {
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(tint.opacity(0.9))
                    .frame(width: 4, height: 4)
                    .offset(y: -3.5)
                    .rotationEffect(.degrees(Double(i) * 72))
            }
            Circle().fill(Color.white).frame(width: 3, height: 3)
        }
        .position(x: x, y: y)
    }
}
