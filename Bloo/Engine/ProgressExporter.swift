import Foundation

struct ProgressSummary {
    let trackingSince: Date?
    let daysLogged: Int
    let totalXP: Int
    let perfectDays: Int
    let longestStreak: Int
    let habitStreaks: [(id: UUID, name: String, streak: Int)]
}

enum ProgressExporter {
    static func summary(habits: [Habit], dailyLogs: [DailyLog]) -> ProgressSummary {
        ProgressSummary(
            trackingSince: dailyLogs.map(\.date).min(),
            daysLogged: dailyLogs.count,
            totalXP: dailyLogs.reduce(0) { $0 + $1.xpEarned },
            perfectDays: dailyLogs.filter(\.isPerfectDay).count,
            longestStreak: dailyLogs.map(\.streakDayNumber).max() ?? 0,
            habitStreaks: habits.map { ($0.id, $0.name, HabitStreakCalculator.currentStreak(for: $0)) }
        )
    }

    static func report(from summary: ProgressSummary) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium

        var lines = ["🌱 Bloo Progress Report", ""]
        if let trackingSince = summary.trackingSince {
            lines.append("Tracking since: \(dateFormatter.string(from: trackingSince))")
        }
        lines.append("Days logged: \(summary.daysLogged)")
        lines.append("Total XP earned: \(summary.totalXP)")
        lines.append("Perfect days: \(summary.perfectDays)")
        lines.append("Longest streak: \(summary.longestStreak) days")
        lines.append("")
        lines.append("Habits")
        for entry in summary.habitStreaks {
            lines.append("- \(entry.name): \(entry.streak)-day current streak")
        }

        return lines.joined(separator: "\n")
    }
}
