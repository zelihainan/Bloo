//
//  BadgeType.swift
//  Bloo
//

import Foundation

/// The 8 achievements shown on the Collections screen. Display title/description
/// strings are localized where the Collections UI is built (String Catalog).
enum BadgeType: String, CaseIterable, Codable, Identifiable, Hashable {
    case firstStep        // Complete your first habit
    case perfectDay        // Complete all habits in one day
    case sevenDayStreak    // Stay consistent for 7 days
    case habitMaster       // Complete 50 habits total
    case thirtyDayStreak   // Stay consistent for 30 days
    case century           // Complete 100 habits total
    case hundredDayStreak  // Stay consistent for 100 days
    case collector         // Unlock 5 Bloos

    var id: String { rawValue }

    var iconSystemName: String {
        switch self {
        case .firstStep: "leaf.fill"
        case .perfectDay: "sparkles"
        case .sevenDayStreak: "flame.fill"
        case .habitMaster: "figure.arms.open"
        case .thirtyDayStreak: "calendar"
        case .century: "text.badge.checkmark"
        case .hundredDayStreak: "trophy.fill"
        case .collector: "pawprint.fill"
        }
    }

    /// Figma uses literal emoji for these, not SF Symbols (node 16:15).
    var emoji: String {
        switch self {
        case .firstStep: "🌱"
        case .perfectDay: "✨"
        case .sevenDayStreak: "🔥"
        case .habitMaster: "💪"
        case .thirtyDayStreak: "📅"
        case .century: "💯"
        case .hundredDayStreak: "🏆"
        case .collector: "🐾"
        }
    }

    /// The icon circle's background color when earned. Bumped more vivid than the
    /// original pale Figma pastels per user feedback — the washed-out tones made
    /// earned badges hard to tell apart at a glance.
    var circleColorHex: String {
        switch self {
        case .firstStep: "#7ED957"
        case .perfectDay: "#3DDC97"
        case .sevenDayStreak: "#FF7A59"
        case .habitMaster: "#4FA8FF"
        case .thirtyDayStreak: "#22D3EE"
        case .century: "#9B7CFF"
        case .hundredDayStreak: "#FFB020"
        case .collector: "#FF9F5A"
        }
    }

    var title: String {
        switch self {
        case .firstStep: "First Step"
        case .perfectDay: "Perfect Day"
        case .sevenDayStreak: "7 Day Streak"
        case .habitMaster: "Habit Master"
        case .thirtyDayStreak: "30 Day Streak"
        case .century: "Century"
        case .hundredDayStreak: "100 Day Streak"
        case .collector: "Collector"
        }
    }

    var badgeDescription: String {
        switch self {
        case .firstStep: "Complete your first habit"
        case .perfectDay: "Complete all habits in one day"
        case .sevenDayStreak: "Stay consistent for 7 days"
        case .habitMaster: "Complete 50 habits total"
        case .thirtyDayStreak: "Stay consistent for 30 days"
        case .century: "Complete 100 habits total"
        case .hundredDayStreak: "Stay consistent for 100 days"
        case .collector: "Unlock 5 Bloos"
        }
    }
}
