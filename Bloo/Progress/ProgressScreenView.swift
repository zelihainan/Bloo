import SwiftUI
import SwiftData

struct ProgressScreenView: View {
    @Query(filter: #Predicate<Bloo> { $0.stateRawValue == "active" }) private var activeBloos: [Bloo]
    @Query(sort: \Habit.sortOrder) private var habits: [Habit]
    @Query private var dailyLogs: [DailyLog]

    private var activeBloo: Bloo? { activeBloos.first }
    private var accentColor: Color {
        guard let activeBloo else { return BlooTheme.primaryButtonBackground }
        return Color(hex: activeBloo.species.colorHex)
    }

    private var thisWeekDates: [Date] {
        CalendarWeek.datesInWeek(containing: Date())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                    .frame(height: 117)

                WeeklySummaryCardView(
                    weekDates: thisWeekDates,
                    perfectDays: perfectDaysThisWeek,
                    xpEarnedThisWeek: xpEarnedThisWeek,
                    accentColor: accentColor
                )
                .padding(.horizontal, 28)

                HabitActivityChartView(activity: weeklyActivity, accentColor: accentColor)
                    .padding(.horizontal, 28)

                let streakRows = habitStreakRows
                HStack(alignment: .top, spacing: 13) {
                    MonthlyOverviewCardView(weeks: CalendarWeek.recentWeeks(4, endingWith: Date()), state: state(for:), accentColor: accentColor)

                    if habits.count >= 2, let best = streakRows.max(by: { $0.streak < $1.streak }), let worst = streakRows.min(by: { $0.streak < $1.streak }) {
                        VStack(spacing: 13) {
                            HabitStatCardView(title: "Best habit", habitName: best.habit.name, days: best.streak, valueColor: BlooTheme.successColor)
                                .frame(maxHeight: .infinity)
                            HabitStatCardView(title: "Needs attention", habitName: worst.habit.name, days: worst.streak, valueColor: BlooTheme.warningColor)
                                .frame(maxHeight: .infinity)
                        }
                        .frame(maxHeight: .infinity)
                    }
                }
                .padding(.horizontal, 28)

                if !streakRows.isEmpty {
                    HabitStreakCardView(rows: streakRows, accentColor: accentColor)
                        .padding(.horizontal, 28)
                }
            }
            .padding(.bottom, 24)
        }
        .background(BlooTheme.background)
    }

    private var header: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Progress")
                    .font(.bloo(28))
                    .foregroundStyle(BlooTheme.primaryText)
                Spacer().frame(height: 86 - 47.5 - 28)
                Text(String(format: NSLocalizedString("See how far %@ has grown!", comment: ""), activeBloo?.displayName ?? "your Bloo"))
                    .font(.bloo(13))
                    .foregroundStyle(BlooTheme.secondaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(.leading, 28)
            .padding(.top, 47.5)

            if let activeBloo {
                BlooArtworkView(species: activeBloo.species, showsBackdrop: false)
                    .frame(width: 77, height: 77)
                    .padding(.leading, 279)
                    .padding(.top, 40)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func log(for day: Date, calendar: Calendar = .current) -> DailyLog? {
        dailyLogs.first { calendar.isDate($0.date, inSameDayAs: day) }
    }

    private var perfectDaysThisWeek: Set<Date> {
        Set(thisWeekDates.filter { log(for: $0)?.isPerfectDay == true })
    }

    private var xpEarnedThisWeek: Int {
        thisWeekDates.reduce(0) { $0 + (log(for: $1)?.xpEarned ?? 0) }
    }

    private var weeklyActivity: [DayActivity] {
        thisWeekDates.map { date in
            DayActivity(date: date, completedCount: log(for: date)?.completedHabitCount ?? 0, completionRate: log(for: date)?.completionRate ?? 0)
        }
    }

    private func state(for day: Date) -> DayCompletionState {
        guard let log = log(for: day), log.scheduledHabitCount > 0 else { return .noData }
        if log.completionRate >= 1 { return .completed }
        if log.completionRate > 0 { return .partial }
        return .noData
    }

    private var habitStreakRows: [HabitStreakRow] {
        habits
            .map { HabitStreakRow(habit: $0, streak: HabitStreakCalculator.currentStreak(for: $0)) }
            .sorted { $0.streak > $1.streak }
    }
}
