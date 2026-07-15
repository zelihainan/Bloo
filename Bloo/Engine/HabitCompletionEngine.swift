//
//  HabitCompletionEngine.swift
//  Bloo
//

import Foundation
import SwiftData

/// The single place that reacts to a habit being checked/unchecked: recomputes
/// the day's `DailyLog`, applies the XP delta to the active `Bloo`, advances it
/// to the next species when it finishes growing, and awards badges.
enum HabitCompletionEngine {
    @discardableResult
    static func toggleCompletion(for habit: Habit, on date: Date, context: ModelContext) -> Bool {
        let calendar = Calendar.current
        let day = calendar.startOfDay(for: date)

        let newState: Bool
        if let existing = habit.completions.first(where: { calendar.isDate($0.date, inSameDayAs: day) }) {
            existing.isCompleted.toggle()
            newState = existing.isCompleted
        } else {
            let completion = HabitCompletion(date: day, isCompleted: true, habit: habit)
            context.insert(completion)
            newState = true
        }

        recomputeDailyLog(for: day, context: context)
        return newState
    }

    static func recomputeDailyLog(for day: Date, context: ModelContext) {
        let calendar = Calendar.current
        let normalizedDay = calendar.startOfDay(for: day)

        let allHabits = (try? context.fetch(FetchDescriptor<Habit>())) ?? []
        let scheduledHabits = allHabits.filter { $0.isScheduled(on: normalizedDay, calendar: calendar) }
        let scheduledCount = scheduledHabits.count
        let completedCount = scheduledHabits.reduce(into: 0) { count, habit in
            if habit.completions.first(where: { calendar.isDate($0.date, inSameDayAs: normalizedDay) })?.isCompleted == true {
                count += 1
            }
        }
        let completionRate = scheduledCount == 0 ? 0 : Double(completedCount) / Double(scheduledCount)

        let allLogs = (try? context.fetch(FetchDescriptor<DailyLog>())) ?? []

        let yesterday = calendar.date(byAdding: .day, value: -1, to: normalizedDay) ?? normalizedDay
        let yesterdayLog = allLogs.first { calendar.isDate($0.date, inSameDayAs: yesterday) }
        let previousStreak = (yesterdayLog?.completionRate ?? 0) > 0 ? (yesterdayLog?.streakDayNumber ?? 0) : 0
        let newStreak = completionRate > 0 ? previousStreak + 1 : 0

        let newXP = XPCalculator.dailyXP(completionRate: completionRate, streakDays: newStreak)

        // `activeBloo` is nil once every species has already been collected —
        // the streak/XP ledger still needs to keep advancing (Progress and
        // badges depend on it) even though there's no Bloo left to grow.
        let activeBloo = activeBloo(in: context)

        let existingLog = allLogs.first { calendar.isDate($0.date, inSameDayAs: normalizedDay) }
        let previousXPForToday = existingLog?.xpEarned ?? 0

        if let existingLog {
            existingLog.scheduledHabitCount = scheduledCount
            existingLog.completedHabitCount = completedCount
            existingLog.xpEarned = newXP
            existingLog.streakDayNumber = newStreak
            existingLog.bloo = activeBloo
        } else {
            context.insert(DailyLog(
                date: normalizedDay,
                scheduledHabitCount: scheduledCount,
                completedHabitCount: completedCount,
                xpEarned: newXP,
                streakDayNumber: newStreak,
                bloo: activeBloo
            ))
        }

        if let activeBloo {
            activeBloo.xp = max(0, activeBloo.xp + (newXP - previousXPForToday))
            advanceToNextSpeciesIfNeeded(for: activeBloo, context: context)
        }
        awardBadgesIfNeeded(completionRate: completionRate, streakDayNumber: newStreak, context: context)

        try? context.save()
    }

    static func activeBloo(in context: ModelContext) -> Bloo? {
        let descriptor = FetchDescriptor<Bloo>(predicate: #Predicate { $0.stateRawValue == "active" })
        return (try? context.fetch(descriptor))?.first
    }

    /// Once the active Bloo reaches the completion threshold it moves to the
    /// Collection, and the next species in the fixed order unlocks and becomes
    /// active automatically (see the sequential unlock rule agreed for `BlooSpecies`).
    private static func advanceToNextSpeciesIfNeeded(for bloo: Bloo, context: ModelContext) {
        guard bloo.isCompleted, bloo.state != .completed else { return }
        bloo.state = .completed
        bloo.completedAt = Date()

        guard let nextSpecies = bloo.species.next else { return }
        let allBloos = (try? context.fetch(FetchDescriptor<Bloo>())) ?? []
        guard let nextBloo = allBloos.first(where: { $0.species == nextSpecies }) else { return }

        nextBloo.state = .active
        nextBloo.unlockedAt = Date()
        nextBloo.activatedAt = Date()
    }

    private static func awardBadgesIfNeeded(completionRate: Double, streakDayNumber: Int, context: ModelContext) {
        let totalCompleted = ((try? context.fetch(FetchDescriptor<HabitCompletion>())) ?? []).filter(\.isCompleted).count
        let unlockedBlooCount = ((try? context.fetch(FetchDescriptor<Bloo>())) ?? []).filter { $0.state != .locked }.count
        let earnedTypes = Set(((try? context.fetch(FetchDescriptor<Badge>())) ?? []).map(\.type))

        func award(_ type: BadgeType) {
            guard !earnedTypes.contains(type) else { return }
            context.insert(Badge(type: type))
        }

        if totalCompleted >= 1 { award(.firstStep) }
        if completionRate >= 1.0 { award(.perfectDay) }
        if streakDayNumber >= 7 { award(.sevenDayStreak) }
        if totalCompleted >= 50 { award(.habitMaster) }
        if streakDayNumber >= 30 { award(.thirtyDayStreak) }
        if totalCompleted >= 100 { award(.century) }
        if streakDayNumber >= 100 { award(.hundredDayStreak) }
        if unlockedBlooCount >= 5 { award(.collector) }
    }
}
