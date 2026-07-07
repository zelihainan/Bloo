//
//  BlooSpecies.swift
//  Bloo
//

import Foundation

/// The 9 Bloo characters, in their fixed unlock order. Order is automatic —
/// the user never picks which species unlocks next (see `Bloo.state`).
enum BlooSpecies: Int, CaseIterable, Codable, Identifiable {
    case fox = 1            // turuncu  #E8845A
    case dragon = 2          // mavi     #5DCAA5
    case axolotl = 3         // pembe    #D4537E
    case shadowBat = 4       // siyah    #7F77DD
    case emberFox = 5        // kırmızı  #E24B4A
    case sprite = 6          // yeşil    #639922
    case golem = 7           // kahverengi #888780
    case amethystDragon = 8  // mor      #7F77DD
    case snowFox = 9         // beyaz    #85B7EB

    var id: Int { rawValue }

    /// Accent color used for the dynamic app theme while this Bloo is the active companion.
    var colorHex: String {
        switch self {
        case .fox: "#E8845A"
        case .dragon: "#5DCAA5"
        case .axolotl: "#D4537E"
        case .shadowBat: "#7F77DD"
        case .emberFox: "#E24B4A"
        case .sprite: "#639922"
        case .golem: "#888780"
        case .amethystDragon: "#7F77DD"
        case .snowFox: "#85B7EB"
        }
    }

    var assetName: String { "bloo_\(rawValue)" }

    /// The 3 species the player can choose from during onboarding.
    static var starterSpecies: [BlooSpecies] { [.fox, .dragon, .axolotl] }

    var isStarter: Bool { BlooSpecies.starterSpecies.contains(self) }

    /// Next species in the fixed sequence, unlocked once the current active Bloo completes its growth.
    var next: BlooSpecies? { BlooSpecies(rawValue: rawValue + 1) }
}
