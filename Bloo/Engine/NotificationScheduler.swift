//
//  NotificationScheduler.swift
//  Bloo
//

import Foundation
import SwiftData
import UserNotifications

/// Schedules a repeating local notification per (habit, scheduled weekday) — the
/// simplest way to get "remind me on Mon/Wed/Fri at 9am" with UNCalendarNotificationTrigger.
enum NotificationScheduler {
    /// iOS silently drops any pending local notification requests past this count
    /// (system-wide, per app) — we cap ourselves so scheduling degrades predictably
    /// instead of relying on whatever order the OS happens to drop the rest in.
    private static let maxPendingRequests = 64

    static func requestAuthorizationIfNeeded() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    /// Clears everything and reschedules from scratch, reading habits fresh from
    /// `context` (rather than a possibly-stale `@Query` snapshot right after a save).
    /// Habits scheduled every day collapse into a single non-weekday-filtered
    /// trigger instead of 7 — the common case, since "Every Day" is the default —
    /// which keeps normal usage well under the 64-request ceiling.
    static func rescheduleAll(context: ModelContext, dailyRemindersEnabled: Bool) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        guard dailyRemindersEnabled else { return }

        let habits = (try? context.fetch(FetchDescriptor<Habit>())) ?? []
        var remainingSlots = maxPendingRequests
        for habit in habits where habit.isReminderEnabled {
            remainingSlots -= schedule(for: habit, center: center, remainingSlots: remainingSlots)
            if remainingSlots <= 0 { break }
        }
    }

    /// Returns how many requests were actually scheduled, so the caller can track the budget.
    @discardableResult
    private static func schedule(for habit: Habit, center: UNUserNotificationCenter, remainingSlots: Int) -> Int {
        guard remainingSlots > 0 else { return 0 }
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: habit.reminderTime)

        let content = UNMutableNotificationContent()
        content.title = "Bloo"
        content.body = habit.name
        content.sound = .default

        if Set(habit.activeWeekdays) == Set(Weekday.allCases) {
            var trigger = DateComponents()
            trigger.hour = timeComponents.hour
            trigger.minute = timeComponents.minute

            let request = UNNotificationRequest(
                identifier: "\(habit.id.uuidString)-everyday",
                content: content,
                trigger: UNCalendarNotificationTrigger(dateMatching: trigger, repeats: true)
            )
            center.add(request)
            return 1
        }

        var scheduled = 0
        for weekday in habit.activeWeekdays {
            guard scheduled < remainingSlots else { break }
            var trigger = DateComponents()
            trigger.hour = timeComponents.hour
            trigger.minute = timeComponents.minute
            trigger.weekday = weekday.gregorianCalendarWeekday

            let request = UNNotificationRequest(
                identifier: "\(habit.id.uuidString)-\(weekday.rawValue)",
                content: content,
                trigger: UNCalendarNotificationTrigger(dateMatching: trigger, repeats: true)
            )
            center.add(request)
            scheduled += 1
        }
        return scheduled
    }
}
