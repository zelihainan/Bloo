//
//  HabitDraft.swift
//  Bloo
//

import Foundation

/// The form values from Add/Edit Habit, applied to a `Habit` by whoever presented the sheet.
struct HabitDraft {
    var name: String
    var note: String
    var activeWeekdays: [Weekday]
    var isReminderEnabled: Bool
    var reminderTime: Date
}
