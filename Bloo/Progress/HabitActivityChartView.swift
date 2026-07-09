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

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Habit activity")
                    .font(.bloo(18, weight: .semibold))
                    .foregroundStyle(BlooTheme.primaryText)
                Spacer()
                Text("This week")
                    .font(.bloo(13))
                    .foregroundStyle(BlooTheme.secondaryText)
            }

            Chart(activity) { day in
                BarMark(
                    x: .value("Day", weekdayLabel(for: day.date)),
                    y: .value("Completed", day.completedCount)
                )
                .foregroundStyle(RateColorScale.color(forRate: day.completionRate, accent: accentColor))
                .cornerRadius(4)
                .annotation(position: .top) {
                    if day.completedCount > 0 {
                        Text("\(day.completedCount)")
                            .font(.bloo(11))
                            .foregroundStyle(BlooTheme.secondaryText)
                    }
                }
            }
            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisValueLabel()
                        .font(.bloo(11))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 160)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }

    private func weekdayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}
