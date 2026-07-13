//
//  DevTools.swift
//  Bloo
//
//  Debug-only actions for exercising states that are slow or impossible to
//  reach through normal use (onboarding, evolution/unlock celebrations, a
//  fully-earned badge board). Compiled out entirely in Release builds.
//

#if DEBUG
import Foundation
import SwiftData

enum DevTools {
    /// Wipes all Bloos/Habits/Badges and drops back into onboarding.
    static func resetOnboarding(context: ModelContext) {
        for habit in (try? context.fetch(FetchDescriptor<Habit>())) ?? [] { context.delete(habit) }
        for bloo in (try? context.fetch(FetchDescriptor<Bloo>())) ?? [] { context.delete(bloo) }
        for log in (try? context.fetch(FetchDescriptor<DailyLog>())) ?? [] { context.delete(log) }
        for badge in (try? context.fetch(FetchDescriptor<Badge>())) ?? [] { context.delete(badge) }
        try? context.save()
        Bloo.bootstrapSpeciesIfNeeded(in: context)
        UserDefaults.standard.set(false, forKey: AppStorageKey.hasCompletedOnboarding)
    }

    /// Instantly finishes the active Bloo's growth and activates the next species with
    /// an empty name, so Home's NameBlooView sheet (and its unlock confetti) appears
    /// exactly as it would after real progress.
    static func forceEvolveActiveBloo(context: ModelContext) {
        guard let activeBloo = HabitCompletionEngine.activeBloo(in: context) else { return }
        activeBloo.xp = XPCalculator.completionThreshold
        activeBloo.state = .completed
        activeBloo.completedAt = Date()

        guard let nextSpecies = activeBloo.species.next else { return }
        let allBloos = (try? context.fetch(FetchDescriptor<Bloo>())) ?? []
        guard let nextBloo = allBloos.first(where: { $0.species == nextSpecies }) else { return }
        nextBloo.state = .active
        nextBloo.unlockedAt = Date()
        nextBloo.activatedAt = Date()
        nextBloo.customName = nil

        try? context.save()
    }

    /// Awards every badge type, for previewing the fully-earned Collections board.
    static func unlockAllBadges(context: ModelContext) {
        let earnedTypes = Set(((try? context.fetch(FetchDescriptor<Badge>())) ?? []).map(\.type))
        for type in BadgeType.allCases where !earnedTypes.contains(type) {
            context.insert(Badge(type: type))
        }
        try? context.save()
    }

    /// Deletes every badge, back to the all-locked default state.
    static func resetBadges(context: ModelContext) {
        for badge in (try? context.fetch(FetchDescriptor<Badge>())) ?? [] { context.delete(badge) }
        try? context.save()
    }
}
#endif
