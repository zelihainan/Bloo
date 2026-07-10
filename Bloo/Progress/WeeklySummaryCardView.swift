//
//  WeeklySummaryCardView.swift
//  Bloo
//
//  Values from the Figma REST API (node 10:239): big numbers are 20px Bold,
//  "/ 7 days" is 10px BOLD (not medium), day dots are 10px, weekday labels are
//  8px Light #B0A898, "This week" is 9px #B0A898.
//

import SwiftUI

/// "X / 7 days completed" + Mon...Sun dots + XP earned + a progress bar for the week.
struct WeeklySummaryCardView: View {
    let weekDates: [Date]
    let perfectDays: Set<Date>
    let xpEarnedThisWeek: Int
    let accentColor: Color

    private var daysCompleted: Int { perfectDays.count }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(daysCompleted)")
                            .font(.bloo(26, weight: .bold))
                            .foregroundStyle(accentColor)
                        Text("/ 7 days")
                            .font(.bloo(14, weight: .bold))
                            .foregroundStyle(BlooTheme.secondaryText)
                    }
                    Text("completed")
                        .font(.bloo(12))
                        .foregroundStyle(BlooTheme.secondaryText)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    Text("This week")
                        .font(.bloo(11))
                        .foregroundStyle(BlooTheme.tertiaryText)
                    HStack(spacing: 12) {
                        ForEach(weekDates, id: \.self) { date in
                            dayDot(for: date)
                        }
                    }
                }
            }

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("+\(xpEarnedThisWeek)")
                    .font(.bloo(26, weight: .bold))
                    .foregroundStyle(accentColor)
                Text("XP earned!")
                    .font(.bloo(12))
                    .foregroundStyle(BlooTheme.secondaryText)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(BlooTheme.cardBorder).frame(height: 4)
                    Capsule()
                        .fill(accentColor)
                        .frame(width: proxy.size.width * (Double(daysCompleted) / 7), height: 4)
                }
            }
            .frame(height: 4)
        }
        .padding(20)
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
                .font(.bloo(10, weight: .medium))
                .foregroundStyle(BlooTheme.tertiaryText)
        }
    }

    private func weekdayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}
