import Foundation

enum CalendarWeek {
    static func datesInWeek(containing date: Date, calendar: Calendar = .current) -> [Date] {
        let day = calendar.startOfDay(for: date)
        let weekdayValue = Weekday(gregorianCalendarWeekday: calendar.component(.weekday, from: day))?.rawValue ?? 1
        guard let monday = calendar.date(byAdding: .day, value: -(weekdayValue - 1), to: day) else { return [day] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: monday) }
    }

    static func recentWeeks(_ weekCount: Int, endingWith date: Date, calendar: Calendar = .current) -> [[Date]] {
        let thisWeek = datesInWeek(containing: date, calendar: calendar)
        guard let thisMonday = thisWeek.first else { return [] }
        return (0..<weekCount).reversed().compactMap { weeksAgo -> [Date]? in
            guard let monday = calendar.date(byAdding: .day, value: -7 * weeksAgo, to: thisMonday) else { return nil }
            return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: monday) }
        }
    }
}
