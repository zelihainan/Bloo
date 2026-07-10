//
//  ManageHabitsView.swift
//  Bloo
//
//  Pushed full-screen from Settings (not presented as a sheet) — relies on the
//  caller providing a NavigationStack.
//

import SwiftUI
import SwiftData

/// Settings > Manage habits: full list with tap-to-edit and swipe-to-delete.
struct ManageHabitsView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage(AppStorageKey.dailyRemindersEnabled) private var dailyRemindersEnabled = true
    @Query(sort: \Habit.sortOrder) private var habits: [Habit]

    @State private var presentedDestination: HabitDestination?

    private static let maxHabitCount = 10

    var body: some View {
        ScrollView {
            if habits.isEmpty {
                Text("No habits yet.")
                    .font(.bloo(15))
                    .foregroundStyle(.secondary)
                    .padding(.top, 40)
            } else {
                VStack(spacing: 12) {
                    ForEach(habits) { habit in
                        row(for: habit)
                    }
                }
                .padding(20)
            }
        }
        .background(BlooTheme.background)
        .navigationTitle("Manage habits")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    presentedDestination = .new
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(habits.count >= Self.maxHabitCount)
            }
        }
        .navigationDestination(item: $presentedDestination) { destination in
            switch destination {
            case .new:
                AddEditHabitView(mode: .new) { draft in save(draft: draft) }
            case .edit(let habit):
                AddEditHabitView(mode: .edit(habit)) { draft in
                    update(habit, with: draft)
                } onDelete: {
                    delete(habit)
                }
            }
        }
    }

    private func row(for habit: Habit) -> some View {
        Button {
            presentedDestination = .edit(habit)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(habit.name)
                        .font(.bloo(16))
                        .foregroundStyle(.primary)
                    Text(scheduleSummary(for: habit))
                        .font(.bloo(12))
                        .foregroundStyle(.secondary)
                    if !habit.note.isEmpty {
                        Text(habit.note)
                            .font(.bloo(12, italic: true))
                            .foregroundStyle(BlooTheme.tertiaryText)
                            .lineLimit(1)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.bloo(12))
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 18)
            .blooFieldBackground()
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) { delete(habit) } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private func scheduleSummary(for habit: Habit) -> String {
        let days = Set(habit.activeWeekdays)
        if days == Set(Weekday.allCases) { return "Every day" }
        if days == Set(Weekday.weekdays) { return "Weekdays" }
        if days == Set(Weekday.weekendDays) { return "Weekends" }
        return habit.activeWeekdays.sorted { $0.rawValue < $1.rawValue }.map(\.shortLabel).joined(separator: ", ")
    }

    private func save(draft: HabitDraft) {
        let habit = Habit(
            name: draft.name,
            note: draft.note,
            activeWeekdays: draft.activeWeekdays,
            isReminderEnabled: draft.isReminderEnabled,
            reminderTime: draft.reminderTime,
            sortOrder: habits.count
        )
        modelContext.insert(habit)
        try? modelContext.save()
        reschedule()
    }

    private func update(_ habit: Habit, with draft: HabitDraft) {
        habit.name = draft.name
        habit.note = draft.note
        habit.activeWeekdays = draft.activeWeekdays
        habit.isReminderEnabled = draft.isReminderEnabled
        habit.reminderTime = draft.reminderTime
        try? modelContext.save()
        reschedule()
    }

    private func delete(_ habit: Habit) {
        modelContext.delete(habit)
        try? modelContext.save()
        reschedule()
    }

    private func reschedule() {
        NotificationScheduler.rescheduleAll(context: modelContext, dailyRemindersEnabled: dailyRemindersEnabled)
    }
}
