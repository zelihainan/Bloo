import Foundation

enum BlooSpecies: Int, CaseIterable, Codable, Identifiable {
    case fox = 1
    case dragon = 2
    case axolotl = 3
    case shadowBat = 4
    case emberFox = 5
    case sprite = 6
    case golem = 7
    case amethystDragon = 8
    case snowFox = 9

    var id: Int { rawValue }

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

    static var starterSpecies: [BlooSpecies] { [.fox, .dragon, .axolotl] }

    var isStarter: Bool { BlooSpecies.starterSpecies.contains(self) }

    var next: BlooSpecies? { BlooSpecies(rawValue: rawValue + 1) }
}
