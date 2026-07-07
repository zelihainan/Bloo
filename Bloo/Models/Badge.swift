//
//  Badge.swift
//  Bloo
//

import Foundation
import SwiftData

/// Only created once earned — a badge's "locked" state is simply the absence of a row,
/// i.e. `BadgeType.allCases` minus the types present in the store.
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
