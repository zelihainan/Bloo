import SwiftUI

struct HabitXPPopup: Identifiable, Equatable {
    let id = UUID()
    let habitID: UUID
    let amount: Int
}

struct TodayHabitsCardView: View {
    let habits: [Habit]
    let totalHabitCount: Int
    let isCompleted: (Habit) -> Bool
    let onToggle: (Habit) -> Void
    let onEdit: (Habit) -> Void
    let onDelete: (Habit) -> Void
    let onAddHabit: () -> Void
    var xpPopup: HabitXPPopup? = nil

    private var isAtHabitLimit: Bool { totalHabitCount >= HabitStore.maxHabitCount }

    @Environment(\.blooAccentColor) private var accentColor
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Today's habits")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.bloo(18, weight: .semibold))
                    .foregroundStyle(BlooTheme.primaryText)
                    .padding(.horizontal, 20)
                    .padding(.top, 13)

                Spacer().frame(height: 11)

                if habits.isEmpty {
                    Text("No habits scheduled for today.")
                        .font(.bloo(13))
                        .foregroundStyle(BlooTheme.secondaryText)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                } else {
                    VStack(spacing: 16) {
                        ForEach(habits) { habit in
                            row(for: habit)
                        }
                    }
                    .padding(.leading, 11)
                    .padding(.trailing, 16)
                    .padding(.bottom, 28)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous)
                    .stroke(BlooTheme.cardBorder, lineWidth: 1)
            )

            VStack(spacing: 6) {
                addHabitButton
                if isAtHabitLimit {
                    Text(String(format: NSLocalizedString("You've reached the %d-habit limit", comment: ""), HabitStore.maxHabitCount))
                        .font(.bloo(11))
                        .foregroundStyle(BlooTheme.tertiaryText)
                }
            }
        }
    }

    private var addHabitButton: some View {
        Button(action: onAddHabit) {
            HStack(spacing: 4) {
                ZStack {
                    Circle().fill(BlooTheme.primaryText).frame(width: 13, height: 13)
                    Text("+")
                        .font(.bloo(10, weight: .semibold))
                        .foregroundStyle(Color(hex: "#D9D9D9"))
                }
                Text("Add a habit")
                    .font(.bloo(13, weight: .semibold))
                    .foregroundStyle(BlooTheme.primaryText)
                    .lineLimit(1)
            }
            .padding(.horizontal, 20)
            .frame(minWidth: 151, minHeight: 43)
            .background(BlooTheme.secondaryText.opacity(0.1))
            .clipShape(Capsule())
        }
        .buttonStyle(.pressable)
        .disabled(isAtHabitLimit)
    }

    private func row(for habit: Habit) -> some View {
        let completed = isCompleted(habit)
        return HStack(spacing: 10) {
            Button {
                onToggle(habit)
            } label: {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(completed ? accentColor : Color.white)
                    .frame(width: 18, height: 18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(completed ? accentColor : BlooTheme.checkboxBorder, lineWidth: 1.5)
                    )
                    .overlay {
                        if completed {
                            Image(systemName: "checkmark")
                                .font(.bloo(10, weight: .bold))
                                .foregroundStyle(.white)
                                .transition(.scale.combined(with: .opacity))
                                .symbolEffect(.bounce, value: completed)
                        }
                    }
                    .scaleEffect(completed ? 1.08 : 1)
                    .animation(reduceMotion ? nil : .spring(response: 0.3, dampingFraction: 0.55), value: completed)
            }
            .buttonStyle(.pressable)
            .contentShape(Rectangle().inset(by: -13))
            .accessibilityLabel(Text(habit.name))
            .accessibilityValue(completed ? Text("Completed") : Text("Not completed"))
            .accessibilityAddTraits(.isButton)

            Button {
                onEdit(habit)
            } label: {
                VStack(alignment: .leading, spacing: 1) {
                    Text(habit.name)
                        .font(.bloo(13))
                        .foregroundStyle(completed ? BlooTheme.secondaryText : BlooTheme.primaryText)
                        .strikethrough(completed)
                    if !habit.note.isEmpty {
                        Text(habit.note)
                            .font(.bloo(10, italic: true))
                            .foregroundStyle(BlooTheme.tertiaryText)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(minHeight: 33)
                .padding(.horizontal, 16)
                .padding(.vertical, habit.note.isEmpty ? 0 : 6)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(BlooTheme.cardBorder, lineWidth: 1))
                .contentShape(Rectangle())
            }
            .buttonStyle(.pressable)
        }
        .overlay(alignment: .topLeading) {
            if let xpPopup, xpPopup.habitID == habit.id {
                FloatingXPText(amount: xpPopup.amount, color: accentColor)
                    .offset(x: 4, y: -6)
                    .id(xpPopup.id)
            }
        }
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

private struct FloatingXPText: View {
    let amount: Int
    let color: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var hasFloated = false

    var body: some View {
        Text("+\(amount) XP")
            .font(.bloo(11, weight: .bold))
            .foregroundStyle(color)
            .offset(y: hasFloated ? -22 : 0)
            .opacity(hasFloated ? 0 : 1)
            .onAppear {
                withAnimation(reduceMotion ? nil : .easeOut(duration: 0.9)) {
                    hasFloated = true
                }
            }
    }
}
