//
//  HabitStore.swift
//  Bloo
//
//  Single place for habit create/update/delete — previously duplicated across
//  Home, Manage Habits, and onboarding, which meant a fix to one (like
//  recomputing today's DailyLog) didn't reach the others.
//

import Foundation
import SwiftData

enum HabitStore {
    /// Habits share the growth economy 1:1 with reminder notifications, both of
    /// which are bounded — this is the single source of truth other call sites
    /// should reference instead of hardcoding "10" themselves.
    static let maxHabitCount = 10

    static func create(draft: HabitDraft, sortOrder: Int, context: ModelContext, dailyRemindersEnabled: Bool) {
        let habit = Habit(
            name: draft.name,
            note: draft.note,
            activeWeekdays: draft.activeWeekdays,
            isReminderEnabled: draft.isReminderEnabled,
            reminderTime: draft.reminderTime,
            sortOrder: sortOrder
        )
        context.insert(habit)
        save(context: context, dailyRemindersEnabled: dailyRemindersEnabled)
    }

    static func update(_ habit: Habit, with draft: HabitDraft, context: ModelContext, dailyRemindersEnabled: Bool) {
        habit.name = draft.name
        habit.note = draft.note
        habit.activeWeekdays = draft.activeWeekdays
        habit.isReminderEnabled = draft.isReminderEnabled
        habit.reminderTime = draft.reminderTime
        save(context: context, dailyRemindersEnabled: dailyRemindersEnabled)
    }

    static func delete(_ habit: Habit, context: ModelContext, dailyRemindersEnabled: Bool) {
        context.delete(habit)
        save(context: context, dailyRemindersEnabled: dailyRemindersEnabled)
    }

    private static func save(context: ModelContext, dailyRemindersEnabled: Bool) {
        try? context.save()
        HabitCompletionEngine.recomputeDailyLog(for: Date(), context: context)
        NotificationScheduler.rescheduleAll(context: context, dailyRemindersEnabled: dailyRemindersEnabled)
    }
}
