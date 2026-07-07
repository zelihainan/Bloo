//
//  XPCalculator.swift
//  Bloo
//

import Foundation

/// Pure XP math, kept separate from the models so the exact rules are easy to audit:
///
/// Daily base XP (by day completion rate): 0% → 0, 1-49% → 5, 50-79% → 10, 80-99% → 15, 100% → 20
/// Streak bonus (by consecutive-day streak): 3d → +2, 7d → +3, 14d → +4, 30d → +5
/// Daily total is capped at 25 XP.
///
/// Evolution thresholds: 0-150 Baby, 151-400 Young, 401-699 Adult, 700+ completed (moves to Collection).
enum XPCalculator {
    static let completionThreshold = 700
    static let dailyCap = 25

    static func baseXP(forCompletionRate rate: Double) -> Int {
        switch rate {
        case 1.0: 20
        case 0.8..<1.0: 15
        case 0.5..<0.8: 10
        case 0.0001..<0.5: 5
        default: 0
        }
    }

    static func streakBonus(forStreakDays days: Int) -> Int {
        switch days {
        case 30...: 5
        case 14..<30: 4
        case 7..<14: 3
        case 3..<7: 2
        default: 0
        }
    }

    static func dailyXP(completionRate rate: Double, streakDays: Int) -> Int {
        min(baseXP(forCompletionRate: rate) + streakBonus(forStreakDays: streakDays), dailyCap)
    }
}
