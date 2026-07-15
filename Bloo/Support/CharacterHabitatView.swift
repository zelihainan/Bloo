//
//  CharacterHabitatView.swift
//  Bloo
//
//  A small pastel "mini scene" behind a Bloo's portrait: soft sky gradient,
//  distant hills, a couple of drifting clouds, a round grass platform with
//  rocks/flowers/plants, and a sprinkle of floating leaves + sparkles. Purely
//  a decorative backdrop — the caller layers the character portrait on top,
//  unchanged in position or size.
//

import SwiftUI

struct CharacterHabitatView: View {
    var speciesHex: String
    var size: CGFloat = 219

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animate = false

    private var skyTop: Color { Color.pastel(hex: "#7EC8FF", fraction: 0.30) }
    private var skyBottom: Color { Color.pastel(hex: speciesHex, fraction: 0.12) }
    private var hillColor: Color { Color.pastel(hex: "#5FBF82", fraction: 0.45) }
    private var grassColor: Color { Color(hex: "#93D6A0") }
    private var grassShadow: Color { Color(hex: "#6FB878") }
    private var dirtColor: Color { Color(hex: "#E4CB9C") }

    var body: some View {
        ZStack {
            LinearGradient(colors: [skyTop, skyBottom], startPoint: .top, endPoint: .bottom)
            hills
            clouds
            sparkles
            leaves
            platform
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }

    // MARK: - Sky layer

    private var hills: some View {
        ZStack {
            Ellipse()
                .fill(hillColor.opacity(0.5))
                .frame(width: size * 0.95, height: size * 0.5)
                .offset(y: size * 0.16)
            Ellipse()
                .fill(hillColor.opacity(0.35))
                .frame(width: size * 0.65, height: size * 0.38)
                .offset(x: size * 0.12, y: size * 0.19)
        }
    }

    private var clouds: some View {
        ZStack {
            cloud(x: -size * 0.30, y: -size * 0.33, symbolSize: 20, drift: 6)
            cloud(x: size * 0.28, y: -size * 0.27, symbolSize: 13, drift: -5)
        }
    }

    private func cloud(x: CGFloat, y: CGFloat, symbolSize: CGFloat, drift: CGFloat) -> some View {
        Image(systemName: "cloud.fill")
            .font(.system(size: symbolSize))
            .foregroundStyle(Color.white.opacity(0.85))
            .offset(x: x + (animate ? drift : -drift), y: y)
    }

    private var sparkles: some View {
        ZStack {
            sparkle(x: size * 0.34, y: -size * 0.10, symbolSize: 9)
            sparkle(x: -size * 0.35, y: size * 0.02, symbolSize: 7)
        }
    }

    private func sparkle(x: CGFloat, y: CGFloat, symbolSize: CGFloat) -> some View {
        Image(systemName: "sparkle")
            .font(.system(size: symbolSize))
            .foregroundStyle(Color.white.opacity(animate ? 0.9 : 0.35))
            .offset(x: x, y: y)
    }

    private var leaves: some View {
        ZStack {
            leaf(x: -size * 0.33, y: -size * 0.20, rotation: -20, tint: hillColor)
            leaf(x: size * 0.36, y: -size * 0.02, rotation: 25, tint: grassShadow)
        }
    }

    private func leaf(x: CGFloat, y: CGFloat, rotation: Double, tint: Color) -> some View {
        Image(systemName: "leaf.fill")
            .font(.system(size: 10))
            .foregroundStyle(tint.opacity(0.75))
            .rotationEffect(.degrees(rotation + (animate ? 10 : -10)))
            .offset(y: animate ? -4 : 4)
            .offset(x: x, y: y)
    }

    // MARK: - Platform

    private var platform: some View {
        ZStack {
            Ellipse()
                .fill(dirtColor)
                .frame(width: size * 0.66, height: size * 0.22)
                .offset(y: size * 0.30)

            Ellipse()
                .fill(LinearGradient(colors: [grassColor, grassShadow], startPoint: .top, endPoint: .bottom))
                .frame(width: size * 0.64, height: size * 0.16)
                .offset(y: size * 0.235)

            rock(x: -size * 0.25, y: size * 0.305, diameter: 10)
            rock(x: size * 0.27, y: size * 0.315, diameter: 7)

            flower(x: -size * 0.31, y: size * 0.235, tint: .pink)
            flower(x: size * 0.19, y: size * 0.195, tint: .yellow)

            plant(x: size * 0.31, y: size * 0.23)
            plant(x: -size * 0.10, y: size * 0.205)
        }
    }

    private func rock(x: CGFloat, y: CGFloat, diameter: CGFloat) -> some View {
        Circle()
            .fill(Color(hex: "#C7C0B4"))
            .frame(width: diameter, height: diameter * 0.8)
            .offset(x: x, y: y)
    }

    private func plant(x: CGFloat, y: CGFloat) -> some View {
        Image(systemName: "leaf.fill")
            .font(.system(size: 9))
            .foregroundStyle(grassShadow)
            .rotationEffect(.degrees(-20))
            .offset(x: x, y: y)
    }

    private func flower(x: CGFloat, y: CGFloat, tint: Color) -> some View {
        ZStack {
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(tint.opacity(0.85))
                    .frame(width: 4, height: 4)
                    .offset(y: -3.5)
                    .rotationEffect(.degrees(Double(i) * 72))
            }
            Circle().fill(Color.white).frame(width: 3, height: 3)
        }
        .offset(x: x, y: y)
    }
}
