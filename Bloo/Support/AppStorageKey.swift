//
//  AppStorageKey.swift
//  Bloo
//

import Foundation

/// Centralized UserDefaults/@AppStorage keys, so call sites can't typo them.
enum AppStorageKey {
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
    static let dailyRemindersEnabled = "dailyRemindersEnabled"
    static let defaultReminderHour = "defaultReminderHour"
    static let defaultReminderMinute = "defaultReminderMinute"
    static let appLanguage = "appLanguage"
}
