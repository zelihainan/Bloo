//
//  HabitCompletion.swift
//  Bloo
//

import Foundation
import SwiftData

/// One record per habit per day. This is the source of truth behind streaks,
/// the monthly calendar heatmap, and the weekly activity chart — it persists
/// even if the habit's schedule or the active Bloo later changes.
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
