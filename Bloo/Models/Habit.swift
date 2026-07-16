import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var name: String
    var note: String
    var activeWeekdaysRawValues: [Int]
    var isReminderEnabled: Bool
    var reminderTime: Date
    var createdAt: Date
    var sortOrder: Int

    @Relationship(deleteRule: .cascade, inverse: \HabitCompletion.habit)
    var completions: [HabitCompletion] = []

    init(
        name: String,
        note: String = "",
        activeWeekdays: [Weekday] = Weekday.allCases,
        isReminderEnabled: Bool = false,
        reminderTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date(),
        sortOrder: Int = 0
    ) {
        self.id = UUID()
        self.name = name
        self.note = note
        self.activeWeekdaysRawValues = activeWeekdays.map(\.rawValue)
        self.isReminderEnabled = isReminderEnabled
        self.reminderTime = reminderTime
        self.createdAt = Date()
        self.sortOrder = sortOrder
    }

    var activeWeekdays: [Weekday] {
        get { activeWeekdaysRawValues.compactMap(Weekday.init(rawValue:)) }
        set { activeWeekdaysRawValues = newValue.map(\.rawValue) }
    }

    func isScheduled(on date: Date, calendar: Calendar = .current) -> Bool {
        guard let weekday = Weekday(gregorianCalendarWeekday: calendar.component(.weekday, from: date)) else {
            return false
        }
        return activeWeekdaysRawValues.contains(weekday.rawValue)
    }
}
