//
//  DailyLog.swift
//  Bloo
//

import Foundation
import SwiftData

/// One row per calendar day: the day's overall completion rate, the XP it earned,
/// and which Bloo that XP went towards. Backs the Progress screen's weekly/monthly
/// views and the streak/XP engine, without needing to recompute from every
/// `HabitCompletion` each time.
@Model
final class DailyLog {
    var id: UUID
    var date: Date
    var scheduledHabitCount: Int
    var completedHabitCount: Int
    var xpEarned: Int
    /// Consecutive-day streak count as of this day (0 if the streak was broken that day).
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
