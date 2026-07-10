//
//  BestHabitCardsView.swift
//  Bloo
//
//  161x90 cards (Figma node 10:239, Rectangle 63/64) — label 9px, habit name
//  11px, day count 11px in the semantic success/warning color.
//

import SwiftUI

/// "Best habit" / "Needs attention" cards — the top row of Progress's 2x2 stat grid.
struct BestHabitCardsView: View {
    let bestHabit: Habit
    let bestStreak: Int
    let worstHabit: Habit
    let worstStreak: Int

    var body: some View {
        HStack(spacing: 13) {
            card(title: "Best habit", habitName: bestHabit.name, days: bestStreak, valueColor: BlooTheme.successColor)
            card(title: "Needs attention", habitName: worstHabit.name, days: worstStreak, valueColor: BlooTheme.warningColor)
        }
    }

    private func card(title: String, habitName: String, days: Int, valueColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.bloo(12))
                .foregroundStyle(BlooTheme.secondaryText)
            Text(habitName)
                .font(.bloo(15, weight: .medium))
                .foregroundStyle(BlooTheme.primaryText)
                .lineLimit(1)
            Text("\(days) Day\(days == 1 ? "" : "s")")
                .font(.bloo(14, weight: .medium))
                .foregroundStyle(valueColor)
        }
        .frame(maxWidth: .infinity, minHeight: 90, alignment: .topLeading)
        .padding(13)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }
}
