//
//  BestHabitCardsView.swift
//  Bloo
//

import SwiftUI

/// Side-by-side "Best habit" / "Needs attention" cards.
struct BestHabitCardsView: View {
    let bestHabit: Habit
    let bestStreak: Int
    let worstHabit: Habit
    let worstStreak: Int

    var body: some View {
        HStack(spacing: 16) {
            card(title: "Best habit", habitName: bestHabit.name, days: bestStreak, valueColor: BlooTheme.successColor)
            card(title: "Needs attention", habitName: worstHabit.name, days: worstStreak, valueColor: BlooTheme.warningColor)
        }
    }

    private func card(title: String, habitName: String, days: Int, valueColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.bloo(13))
                .foregroundStyle(BlooTheme.secondaryText)
            Text(habitName)
                .font(.bloo(16, weight: .semibold))
                .foregroundStyle(BlooTheme.primaryText)
                .lineLimit(1)
            Text("\(days) Day\(days == 1 ? "" : "s")")
                .font(.bloo(15, weight: .semibold))
                .foregroundStyle(valueColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }
}
