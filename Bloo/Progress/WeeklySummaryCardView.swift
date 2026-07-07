//
//  WeeklySummaryCardView.swift
//  Bloo
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
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(daysCompleted)")
                            .font(.bloo(30, weight: .bold))
                            .foregroundStyle(accentColor)
                        Text("/ 7 days")
                            .font(.bloo(16, weight: .medium))
                    }
                    Text("completed")
                        .font(.bloo(13))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(spacing: 6) {
                    ForEach(weekDates, id: \.self) { date in
                        dayDot(for: date)
                    }
                }
            }

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("+\(xpEarnedThisWeek)")
                    .font(.bloo(24, weight: .bold))
                    .foregroundStyle(accentColor)
                Text("XP earned!")
                    .font(.bloo(14))
                    .foregroundStyle(.secondary)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.gray.opacity(0.15))
                    Capsule()
                        .fill(accentColor)
                        .frame(width: proxy.size.width * (Double(daysCompleted) / 7))
                }
            }
            .frame(height: 8)
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
        return VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(isDone ? accentColor : Color.gray.opacity(0.12))
                    .frame(width: 22, height: 22)
                if isDone {
                    Image(systemName: "checkmark")
                        .font(.bloo(10, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            Text(weekdayLabel(for: date))
                .font(.bloo(10))
                .foregroundStyle(.secondary)
        }
    }

    private func weekdayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}
