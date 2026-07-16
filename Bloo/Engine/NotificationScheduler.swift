import Foundation
import SwiftData
import UserNotifications

enum NotificationScheduler {
    private static let maxPendingRequests = 64

    static func requestAuthorizationIfNeeded() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    static func isAuthorized() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
    }

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
