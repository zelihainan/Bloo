//
//  HabitStreakCalculator.swift
//  Bloo
//

import Foundation

enum HabitStreakCalculator {
    /// Consecutive scheduled days (walking backward from today) the habit was completed.
    /// If today is scheduled but not completed yet, it's simply skipped rather than
    /// breaking the streak — the day isn't over yet.
    static func currentStreak(for habit: Habit, calendar: Calendar = .current) -> Int {
        let today = calendar.startOfDay(for: Date())
        let creationDay = calendar.startOfDay(for: habit.createdAt)
        var day = today

        if habit.isScheduled(on: today, calendar: calendar), !isCompleted(habit, on: today, calendar: calendar) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: today) else { return 0 }
            day = yesterday
        }

        var streak = 0
        while day >= creationDay {
            if habit.isScheduled(on: day, calendar: calendar) {
                guard isCompleted(habit, on: day, calendar: calendar) else { break }
                streak += 1
            }
            guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previous
        }
        return streak
    }

    private static func isCompleted(_ habit: Habit, on day: Date, calendar: Calendar) -> Bool {
        habit.completions.first { calendar.isDate($0.date, inSameDayAs: day) }?.isCompleted ?? false
    }
}
