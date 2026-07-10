//
//  HabitActivityChartView.swift
//  Bloo
//

import SwiftUI
import Charts

struct DayActivity: Identifiable {
    let date: Date
    let completedCount: Int
    let completionRate: Double

    var id: Date { date }
}

/// "Habit activity" bar chart for the current week.
struct HabitActivityChartView: View {
    let activity: [DayActivity]
    let accentColor: Color

    @AppStorage(AppStorageKey.appLanguage) private var appLanguage = "en"

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Habit activity")
                    .font(.bloo(15, weight: .medium))
                    .foregroundStyle(BlooTheme.secondaryText)
                Spacer()
                Text("This week")
                    .font(.bloo(11))
                    .foregroundStyle(BlooTheme.tertiaryText)
            }

            Chart(activity) { day in
                BarMark(
                    x: .value("Day", weekdayLabel(for: day.date)),
                    y: .value("Completed", day.completedCount),
                    width: .fixed(16)
                )
                .foregroundStyle(RateColorScale.color(forRate: day.completionRate, accent: accentColor))
                .cornerRadius(4)
                .annotation(position: .top) {
                    if day.completedCount > 0 {
                        Text("\(day.completedCount)")
                            .font(.bloo(10))
                            .foregroundStyle(BlooTheme.tertiaryText)
                    }
                }
            }
            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisValueLabel()
                        .font(.bloo(10, weight: .medium))
                        .foregroundStyle(BlooTheme.tertiaryText)
                }
            }
            .frame(height: 120)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }

    private func weekdayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: appLanguage)
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}
