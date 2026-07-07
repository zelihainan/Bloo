//
//  OnboardingAddHabitsView.swift
//  Bloo
//

import SwiftUI
import SwiftData

struct OnboardingAddHabitsView: View {
    let onContinue: () -> Void

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.sortOrder) private var habits: [Habit]

    @State private var presentedSheet: SheetKind?

    private static let maxHabitCount = 10

    private enum SheetKind: Identifiable {
        case new
        case edit(Habit)

        var id: String {
            switch self {
            case .new: "new"
            case .edit(let habit): habit.id.uuidString
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer().frame(height: 60)

            Text("Your first habits")
                .font(.system(size: 32, weight: .semibold))
            Text("Start small. Bloo will remind you.")
                .font(.system(size: 17))
                .foregroundStyle(.secondary)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(habits) { habit in
                        habitRow(habit)
                    }
                }
                .padding(.top, 24)
            }

            HStack {
                Spacer()
                Button {
                    presentedSheet = .new
                } label: {
                    Label("Add a habit", systemImage: "plus.circle.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 18)
                        .background(Color.black.opacity(0.06))
                        .clipShape(Capsule())
                }
                .disabled(habits.count >= Self.maxHabitCount)
                Spacer()
            }
            .padding(.vertical, 12)

            Spacer()

            Button("Continue", action: onContinue)
                .buttonStyle(.bloo(isEnabled: !habits.isEmpty))
                .disabled(habits.isEmpty)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlooTheme.background)
        .sheet(item: $presentedSheet) { sheet in
            switch sheet {
            case .new:
                AddEditHabitView(mode: .new) { draft in
                    save(draft: draft, sortOrder: habits.count)
                }
            case .edit(let habit):
                AddEditHabitView(mode: .edit(habit)) { draft in
                    update(habit, with: draft)
                } onDelete: {
                    delete(habit)
                }
            }
        }
    }

    private func habitRow(_ habit: Habit) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "square")
                .foregroundStyle(.secondary)
            Text(habit.name)
                .font(.system(size: 16))
            Spacer()
            Button {
                presentedSheet = .edit(habit)
            } label: {
                Image(systemName: "pencil")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 18)
        .blooFieldBackground()
    }

    private func save(draft: HabitDraft, sortOrder: Int) {
        let habit = Habit(
            name: draft.name,
            note: draft.note,
            activeWeekdays: draft.activeWeekdays,
            isReminderEnabled: draft.isReminderEnabled,
            reminderTime: draft.reminderTime,
            sortOrder: sortOrder
        )
        modelContext.insert(habit)
        try? modelContext.save()
    }

    private func update(_ habit: Habit, with draft: HabitDraft) {
        habit.name = draft.name
        habit.note = draft.note
        habit.activeWeekdays = draft.activeWeekdays
        habit.isReminderEnabled = draft.isReminderEnabled
        habit.reminderTime = draft.reminderTime
        try? modelContext.save()
    }

    private func delete(_ habit: Habit) {
        modelContext.delete(habit)
        try? modelContext.save()
    }
}
