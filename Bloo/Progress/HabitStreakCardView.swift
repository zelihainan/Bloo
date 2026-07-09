//
//  HabitStreakCardView.swift
//  Bloo
//
//  161x182 card (Figma node 10:239, Rectangle 66/99) — the bottom-right of
//  Progress's 2x2 stat grid. Habit name 8px, day count 7px in the accent's
//  darkened ("completed") tier, not plain accent; bar itself IS plain accent.
//

import SwiftUI

struct HabitStreakRow: Identifiable {
    let habit: Habit
    let streak: Int
    var id: UUID { habit.id }
}

/// "Habit streak" card: each habit's current streak with a bar scaled to the longest streak.
struct HabitStreakCardView: View {
    let rows: [HabitStreakRow]
    let accentColor: Color

    private var maxStreak: Int { max(rows.map(\.streak).max() ?? 0, 1) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Habit streak")
                .font(.bloo(13, weight: .medium))
                .foregroundStyle(BlooTheme.secondaryText)

            VStack(spacing: 10) {
                ForEach(rows) { row in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(row.habit.name)
                                .font(.bloo(8))
                                .foregroundStyle(BlooTheme.primaryText)
                                .lineLimit(1)
                            Spacer()
                            Text("\(row.streak) Day\(row.streak == 1 ? "" : "s")")
                                .font(.bloo(7))
                                .foregroundStyle(accentColor.mixed(withBlack: 0.3))
                        }
                        GeometryReader { proxy in
                            ZStack(alignment: .leading) {
                                Capsule().fill(BlooTheme.cardBorder)
                                Capsule()
                                    .fill(accentColor)
                                    .frame(width: proxy.size.width * (Double(row.streak) / Double(maxStreak)))
                            }
                        }
                        .frame(height: 4)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(13)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }
}
