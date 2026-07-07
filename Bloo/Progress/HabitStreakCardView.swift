//
//  HabitStreakCardView.swift
//  Bloo
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
        VStack(alignment: .leading, spacing: 16) {
            Text("Habit streak")
                .font(.bloo(20, weight: .semibold))

            VStack(spacing: 14) {
                ForEach(rows) { row in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(row.habit.name)
                                .font(.bloo(15))
                            Spacer()
                            Text("\(row.streak) Day\(row.streak == 1 ? "" : "s")")
                                .font(.bloo(13, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                        GeometryReader { proxy in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.gray.opacity(0.12))
                                Capsule()
                                    .fill(accentColor)
                                    .frame(width: proxy.size.width * (Double(row.streak) / Double(maxStreak)))
                            }
                        }
                        .frame(height: 6)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }
}
