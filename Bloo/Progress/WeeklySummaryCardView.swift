//
//  WeeklySummaryCardView.swift
//  Bloo
//

import SwiftUI

/// "X / 7 days completed" + Mon...Sun dots + XP earned this week.
struct WeeklySummaryCardView: View {
    let weekDates: [Date]
    let perfectDays: Set<Date>
    let xpEarnedThisWeek: Int
    let accentColor: Color

    @Environment(\.locale) private var locale

    private var daysCompleted: Int { perfectDays.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(daysCompleted)")
                            .font(.bloo(24, weight: .bold))
                            .foregroundStyle(accentColor)
                        Text("/ 7 days")
                            .font(.bloo(13, weight: .bold))
                            .foregroundStyle(BlooTheme.secondaryText)
                    }
                    Text("completed")
                        .font(.bloo(11))
                        .foregroundStyle(BlooTheme.secondaryText)
                }
                Spacer()
                Text("This week")
                    .font(.bloo(11))
                    .foregroundStyle(BlooTheme.tertiaryText)
            }

            HStack(spacing: 0) {
                ForEach(weekDates, id: \.self) { date in
                    dayDot(for: date)
                        .frame(maxWidth: .infinity)
                }
            }

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("+\(xpEarnedThisWeek)")
                    .font(.bloo(24, weight: .bold))
                    .foregroundStyle(accentColor)
                Text("XP earned!")
                    .font(.bloo(11))
                    .foregroundStyle(BlooTheme.secondaryText)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }

    private func dayDot(for date: Date) -> some View {
        let isDone = perfectDays.contains(date)
        return VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(isDone ? accentColor : RateColorScale.noData)
                    .frame(width: 16, height: 16)
                if isDone {
                    Text("✓")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            Text(weekdayLabel(for: date))
                .font(.bloo(9, weight: .medium))
                .foregroundStyle(BlooTheme.tertiaryText)
        }
    }

    private func weekdayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}
