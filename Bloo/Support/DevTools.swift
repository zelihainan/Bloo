#if DEBUG
import Foundation
import SwiftData

enum DevTools {
    static func resetOnboarding(context: ModelContext) {
        for habit in (try? context.fetch(FetchDescriptor<Habit>())) ?? [] { context.delete(habit) }
        for bloo in (try? context.fetch(FetchDescriptor<Bloo>())) ?? [] { context.delete(bloo) }
        for log in (try? context.fetch(FetchDescriptor<DailyLog>())) ?? [] { context.delete(log) }
        for badge in (try? context.fetch(FetchDescriptor<Badge>())) ?? [] { context.delete(badge) }
        context.saveAndLogErrors()
        Bloo.bootstrapSpeciesIfNeeded(in: context)
        UserDefaults.standard.set(false, forKey: AppStorageKey.hasCompletedOnboarding)
    }

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

        context.saveAndLogErrors()
    }

    static func unlockAllBadges(context: ModelContext) {
        let earnedTypes = Set(((try? context.fetch(FetchDescriptor<Badge>())) ?? []).map(\.type))
        for type in BadgeType.allCases where !earnedTypes.contains(type) {
            context.insert(Badge(type: type))
        }
        context.saveAndLogErrors()
    }

    static func resetBadges(context: ModelContext) {
        for badge in (try? context.fetch(FetchDescriptor<Badge>())) ?? [] { context.delete(badge) }
        context.saveAndLogErrors()
    }
}
#endif
