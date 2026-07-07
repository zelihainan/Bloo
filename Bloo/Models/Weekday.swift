//
//  Weekday.swift
//  Bloo
//

import Foundation

/// Monday-first weekday, matching how the habit repeat picker is laid out (Mon...Sun).
enum Weekday: Int, CaseIterable, Codable, Identifiable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday

    var id: Int { rawValue }

    static var weekdays: [Weekday] { [.monday, .tuesday, .wednesday, .thursday, .friday] }
    static var weekendDays: [Weekday] { [.saturday, .sunday] }

    /// `Calendar.component(.weekday, from:)` returns 1 = Sunday ... 7 = Saturday. Convert that to our Monday-first scale.
    init?(gregorianCalendarWeekday: Int) {
        let mapped = gregorianCalendarWeekday == 1 ? 7 : gregorianCalendarWeekday - 1
        self.init(rawValue: mapped)
    }
}
