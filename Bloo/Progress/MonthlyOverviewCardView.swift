//
//  MonthlyOverviewCardView.swift
//  Bloo
//

import SwiftUI

enum DayCompletionState {
    case completed, partial, noData

    var color: Color {
        switch self {
        case .completed: Color(hex: "#8A2846")
        case .partial: Color(hex: "#E9A9BE")
        case .noData: Color.gray.opacity(0.25)
        }
    }
}

/// Rolling 4-week dot grid (Mon...Sun columns), ending with the current week.
struct MonthlyOverviewCardView: View {
    let weeks: [[Date]]
    let state: (Date) -> DayCompletionState

    private let weekdayHeaders = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly overview")
                .font(.system(size: 20, weight: .semibold))

            HStack {
                ForEach(weekdayHeaders.indices, id: \.self) { index in
                    Text(weekdayHeaders[index])
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            VStack(spacing: 10) {
                ForEach(weeks, id: \.self) { week in
                    HStack {
                        ForEach(week, id: \.self) { date in
                            Circle()
                                .fill(state(date).color)
                                .frame(width: 14, height: 14)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }

            HStack(spacing: 16) {
                legendItem(color: DayCompletionState.completed.color, label: "Completed")
                legendItem(color: DayCompletionState.partial.color, label: "Partial")
                legendItem(color: DayCompletionState.noData.color, label: "No data")
            }
            .padding(.top, 4)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
    }
}
