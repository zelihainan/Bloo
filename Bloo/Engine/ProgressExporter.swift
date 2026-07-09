//
//  ProgressExporter.swift
//  Bloo
//

import Foundation

/// Builds the CSV text behind Settings > Export progress.
enum ProgressExporter {
    static func csv(habits: [Habit], dailyLogs: [DailyLog]) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var lines = ["Date,Scheduled,Completed,Completion Rate,XP Earned,Streak Day"]
        for log in dailyLogs.sorted(by: { $0.date < $1.date }) {
            let ratePercent = Int((log.completionRate * 100).rounded())
            lines.append("\(dateFormatter.string(from: log.date)),\(log.scheduledHabitCount),\(log.completedHabitCount),\(ratePercent)%,\(log.xpEarned),\(log.streakDayNumber)")
        }

        lines.append("")
        lines.append("Habit,Current Streak (days)")
        for habit in habits {
            lines.append("\(habit.name),\(HabitStreakCalculator.currentStreak(for: habit))")
        }

        return lines.joined(separator: "\n")
    }
}
