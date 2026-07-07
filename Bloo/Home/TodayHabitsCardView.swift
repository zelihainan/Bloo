//
//  TodayHabitsCardView.swift
//  Bloo
//

import SwiftUI

/// "Today's habits" card: the habits scheduled for today, with a tap-to-toggle
/// checkbox and swipe-to-edit/delete, matching the Home mockup.
struct TodayHabitsCardView: View {
    let habits: [Habit]
    let isCompleted: (Habit) -> Bool
    let onToggle: (Habit) -> Void
    let onEdit: (Habit) -> Void
    let onDelete: (Habit) -> Void
    let onAddHabit: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Today's habits")
                    .font(.bloo(20, weight: .semibold))

                if habits.isEmpty {
                    Text("No habits scheduled for today.")
                        .font(.bloo(15))
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 8)
                } else {
                    VStack(spacing: 12) {
                        ForEach(habits) { habit in
                            row(for: habit)
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

            Button(action: onAddHabit) {
                Label("Add a habit", systemImage: "plus.circle.fill")
                    .font(.bloo(15, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 18)
                    .background(Color.black.opacity(0.06))
                    .clipShape(Capsule())
            }
            .disabled(habits.count >= 10)
        }
    }

    private func row(for habit: Habit) -> some View {
        let completed = isCompleted(habit)
        return HStack(spacing: 12) {
            Button {
                onToggle(habit)
            } label: {
                Image(systemName: completed ? "checkmark.square.fill" : "square")
                    .foregroundStyle(completed ? .green : .secondary)
                    .font(.bloo(20))
            }
            Text(habit.name)
                .font(.bloo(16))
                .strikethrough(completed)
                .foregroundStyle(completed ? .secondary : .primary)
            Spacer()
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 18)
        .blooFieldBackground()
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) { onDelete(habit) } label: {
                Label("Delete", systemImage: "trash")
            }
            Button { onEdit(habit) } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.gray)
        }
    }
}
