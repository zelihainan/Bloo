import Foundation

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
