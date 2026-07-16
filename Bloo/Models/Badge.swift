import Foundation
import SwiftData

@Model
final class Badge {
    var id: UUID
    var typeRawValue: String
    var earnedAt: Date

    init(type: BadgeType, earnedAt: Date = Date()) {
        self.id = UUID()
        self.typeRawValue = type.rawValue
        self.earnedAt = earnedAt
    }

    var type: BadgeType {
        BadgeType(rawValue: typeRawValue) ?? .firstStep
    }
}
