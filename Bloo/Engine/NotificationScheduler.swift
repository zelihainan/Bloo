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
    static func requestAuthorizationIfNeeded() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    /// Clears everything and reschedules from scratch, reading habits fresh from
    /// `context` (rather than a possibly-stale `@Query` snapshot right after a save).
    /// Simple and correct at this app's scale (max 10 habits × up to 7 weekdays =
    /// at most 70 pending requests).
    static func rescheduleAll(context: ModelContext, dailyRemindersEnabled: Bool) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        guard dailyRemindersEnabled else { return }

        let habits = (try? context.fetch(FetchDescriptor<Habit>())) ?? []
        for habit in habits where habit.isReminderEnabled {
            schedule(for: habit, center: center)
        }
    }

    private static func schedule(for habit: Habit, center: UNUserNotificationCenter) {
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: habit.reminderTime)

        let content = UNMutableNotificationContent()
        content.title = "Bloo"
        content.body = habit.name
        content.sound = .default

        for weekday in habit.activeWeekdays {
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
        }
    }
}
