import Foundation
import SwiftData

@Model
final class DailyLog {
    var id: UUID
    var date: Date
    var scheduledHabitCount: Int
    var completedHabitCount: Int
    var xpEarned: Int
    var streakDayNumber: Int
    var bloo: Bloo?

    init(
        date: Date,
        scheduledHabitCount: Int,
        completedHabitCount: Int,
        xpEarned: Int,
        streakDayNumber: Int,
        bloo: Bloo? = nil
    ) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.scheduledHabitCount = scheduledHabitCount
        self.completedHabitCount = completedHabitCount
        self.xpEarned = xpEarned
        self.streakDayNumber = streakDayNumber
        self.bloo = bloo
    }

    var completionRate: Double {
        scheduledHabitCount == 0 ? 0 : Double(completedHabitCount) / Double(scheduledHabitCount)
    }

    var isPerfectDay: Bool {
        scheduledHabitCount > 0 && completedHabitCount == scheduledHabitCount
    }
}
