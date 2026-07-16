import Foundation
import SwiftData

enum BlooLifecycleState: String, Codable {
    case locked
    case unlocked
    case active
    case completed
}

enum EvolutionStage: String, Codable, CaseIterable {
    case baby, young, adult

    init(xp: Int) {
        switch xp {
        case ..<151: self = .baby
        case 151..<401: self = .young
        default: self = .adult
        }
    }
}

@Model
final class Bloo {
    var id: UUID
    var speciesRawValue: Int
    var customName: String?
    var xp: Int
    var stateRawValue: String
    var unlockedAt: Date?
    var activatedAt: Date?
    var completedAt: Date?

    init(species: BlooSpecies, state: BlooLifecycleState = .locked, xp: Int = 0) {
        self.id = UUID()
        self.speciesRawValue = species.rawValue
        self.customName = nil
        self.xp = xp
        self.stateRawValue = state.rawValue
        self.unlockedAt = state == .locked ? nil : Date()
        self.activatedAt = state == .active ? Date() : nil
        self.completedAt = nil
    }

    var species: BlooSpecies {
        BlooSpecies(rawValue: speciesRawValue) ?? .fox
    }

    var state: BlooLifecycleState {
        get { BlooLifecycleState(rawValue: stateRawValue) ?? .locked }
        set { stateRawValue = newValue.rawValue }
    }

    var evolutionStage: EvolutionStage? {
        isCompleted ? nil : EvolutionStage(xp: xp)
    }

    var isCompleted: Bool { xp >= XPCalculator.completionThreshold }

    var displayName: String {
        guard let customName, !customName.isEmpty else { return NSLocalizedString("your Bloo", comment: "") }
        return customName
    }

    var stageProgress: Double {
        guard let stage = evolutionStage else { return 1 }
        let (lower, upper): (Int, Int) = switch stage {
        case .baby: (0, 150)
        case .young: (151, 400)
        case .adult: (401, XPCalculator.completionThreshold)
        }
        return Double(xp - lower) / Double(upper - lower)
    }
}

extension Bloo {
    @discardableResult
    static func bootstrapSpeciesIfNeeded(in context: ModelContext) -> Bool {
        let existingCount = (try? context.fetchCount(FetchDescriptor<Bloo>())) ?? 0
        guard existingCount == 0 else { return false }

        for species in BlooSpecies.allCases {
            let state: BlooLifecycleState = species.isStarter ? .unlocked : .locked
            context.insert(Bloo(species: species, state: state))
        }
        return true
    }
}
