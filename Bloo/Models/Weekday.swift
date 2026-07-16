import Foundation

enum Weekday: Int, CaseIterable, Codable, Identifiable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday

    var id: Int { rawValue }

    static var weekdays: [Weekday] { [.monday, .tuesday, .wednesday, .thursday, .friday] }
    static var weekendDays: [Weekday] { [.saturday, .sunday] }

    init?(gregorianCalendarWeekday: Int) {
        let mapped = gregorianCalendarWeekday == 1 ? 7 : gregorianCalendarWeekday - 1
        self.init(rawValue: mapped)
    }

    var gregorianCalendarWeekday: Int {
        rawValue == 7 ? 1 : rawValue + 1
    }

    var shortLabel: String {
        switch self {
        case .monday: "Mon"
        case .tuesday: "Tue"
        case .wednesday: "Wed"
        case .thursday: "Thu"
        case .friday: "Fri"
        case .saturday: "Sat"
        case .sunday: "Sun"
        }
    }
}
