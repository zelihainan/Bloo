import Foundation

enum HabitDestination: Identifiable {
    case new
    case edit(Habit)

    var id: String {
        switch self {
        case .new: "new"
        case .edit(let habit): habit.id.uuidString
        }
    }
}

extension HabitDestination: Hashable {
    static func == (lhs: HabitDestination, rhs: HabitDestination) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
