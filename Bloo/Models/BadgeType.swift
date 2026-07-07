//
//  BadgeType.swift
//  Bloo
//

import Foundation

/// The 8 achievements shown on the Collections screen. Display title/description
/// strings are localized where the Collections UI is built (String Catalog).
enum BadgeType: String, CaseIterable, Codable, Identifiable {
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
}
