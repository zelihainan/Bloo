import Foundation
import SwiftData

enum HabitStore {
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
        context.saveAndLogErrors()
        HabitCompletionEngine.recomputeDailyLog(for: Date(), context: context)
        NotificationScheduler.rescheduleAll(context: context, dailyRemindersEnabled: dailyRemindersEnabled)
    }
}
