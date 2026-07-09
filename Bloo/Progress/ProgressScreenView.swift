//
//  ProgressScreenView.swift
//  Bloo
//
//  Named "ProgressScreenView" (not "ProgressView") to avoid colliding with
//  SwiftUI's own ProgressView type.
//

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
                    .frame(height: 117) // 40 (icon top) + 77 (icon height), tallest element in the header block

                WeeklySummaryCardView(
                    weekDates: thisWeekDates,
                    perfectDays: perfectDaysThisWeek,
                    xpEarnedThisWeek: xpEarnedThisWeek,
                    accentColor: accentColor
                )
                .padding(.horizontal, 20)

                HabitActivityChartView(activity: weeklyActivity, accentColor: accentColor)
                    .padding(.horizontal, 20)

                if habits.count >= 2, let best = bestHabitRow, let worst = worstHabitRow {
                    BestHabitCardsView(
                        bestHabit: best.habit, bestStreak: best.streak,
                        worstHabit: worst.habit, worstStreak: worst.streak
                    )
                    .padding(.horizontal, 20)
                }

                MonthlyOverviewCardView(weeks: CalendarWeek.recentWeeks(4, endingWith: Date()), state: state(for:))
                    .padding(.horizontal, 20)

                if !habitStreakRows.isEmpty {
                    HabitStreakCardView(rows: habitStreakRows, accentColor: accentColor)
                        .padding(.horizontal, 20)
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
                    .font(.bloo(28, weight: .semibold))
                    .foregroundStyle(BlooTheme.primaryText)
                Spacer().frame(height: 86 - 47.5 - 28)
                Text("See how far \(activeBloo?.displayName ?? "your Bloo") has grown!")
                    .font(.bloo(13))
                    .foregroundStyle(BlooTheme.secondaryText)
            }
            .padding(.leading, 52)
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

    // MARK: - Derived stats

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
        habits.map { HabitStreakRow(habit: $0, streak: HabitStreakCalculator.currentStreak(for: $0)) }
    }

    private var bestHabitRow: HabitStreakRow? {
        habitStreakRows.max { $0.streak < $1.streak }
    }

    private var worstHabitRow: HabitStreakRow? {
        habitStreakRows.min { $0.streak < $1.streak }
    }
}
