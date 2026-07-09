//
//  WeeklySummaryCardView.swift
//  Bloo
//
//  Sizes/colors measured directly from Figma's Progress export: big numbers
//  are 26px Bold in the accent color, day dots are 12px (accent/checked,
//  #D9D9D9/unchecked), weekday labels 9px, "This week" label 11px.
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
                            .font(.bloo(14, weight: .medium))
                            .foregroundStyle(BlooTheme.primaryText)
                    }
                    Text("completed")
                        .font(.bloo(13))
                        .foregroundStyle(BlooTheme.secondaryText)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    Text("This week")
                        .font(.bloo(11))
                        .foregroundStyle(BlooTheme.secondaryText)
                    HStack(spacing: 10) {
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
                    .font(.bloo(13))
                    .foregroundStyle(BlooTheme.secondaryText)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(BlooTheme.cardBorder).frame(height: 6)
                    Capsule()
                        .fill(accentColor)
                        .frame(width: proxy.size.width * (Double(daysCompleted) / 7), height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }

    private func dayDot(for date: Date) -> some View {
        let isDone = perfectDays.contains(date)
        return VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(isDone ? accentColor : RateColorScale.noData)
                    .frame(width: 12, height: 12)
                if isDone {
                    Image(systemName: "checkmark")
                        .font(.system(size: 6, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            Text(weekdayLabel(for: date))
                .font(.bloo(9))
                .foregroundStyle(BlooTheme.secondaryText)
        }
    }

    private func weekdayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}
