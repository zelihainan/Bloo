import Foundation

struct HabitDraft {
    var name: String
    var note: String
    var activeWeekdays: [Weekday]
    var isReminderEnabled: Bool
    var reminderTime: Date
}
