//
//  ManageHabitsView.swift
//  Bloo
//

import SwiftUI
import SwiftData

/// Settings > Manage habits: full list with tap-to-edit and swipe-to-delete.
struct ManageHabitsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @AppStorage(AppStorageKey.dailyRemindersEnabled) private var dailyRemindersEnabled = true
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
        NavigationStack {
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentedSheet = .new
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(habits.count >= Self.maxHabitCount)
                }
            }
        }
        .sheet(item: $presentedSheet) { sheet in
            switch sheet {
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
            presentedSheet = .edit(habit)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(habit.name)
                        .font(.bloo(16))
                        .foregroundStyle(.primary)
                    Text(scheduleSummary(for: habit))
                        .font(.bloo(12))
                        .foregroundStyle(.secondary)
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
