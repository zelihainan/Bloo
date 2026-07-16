import Foundation
import SwiftData

@Model
final class HabitCompletion {
    var id: UUID
    var date: Date
    var isCompleted: Bool
    var habit: Habit?

    init(date: Date, isCompleted: Bool = true, habit: Habit? = nil) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.isCompleted = isCompleted
        self.habit = habit
    }
}
