//
//  MonthlyOverviewCardView.swift
//  Bloo
//

import SwiftUI

enum DayCompletionState {
    case completed, partial, noData
}

/// Rolling 4-week dot grid (Mon...Sun columns), ending with the current week.
/// Dot colors are derived from the active Bloo's accent — measured from Figma
/// (axolotl #D4537E): completed = accent mixed ~30% toward black, partial =
/// accent mixed ~55% toward white, no data = a fixed neutral (#D9D9D9).
struct MonthlyOverviewCardView: View {
    let weeks: [[Date]]
    let state: (Date) -> DayCompletionState
    let accentColor: Color

    private let weekdayHeaders = ["M", "T", "W", "T", "F", "S", "S"]

    private func color(for state: DayCompletionState) -> Color {
        switch state {
        case .completed: accentColor.mixed(withBlack: 0.3)
        case .partial: accentColor.mixed(withWhite: 0.55)
        case .noData: RateColorScale.noData
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly overview")
                .font(.bloo(18, weight: .semibold))
                .foregroundStyle(BlooTheme.primaryText)

            HStack {
                ForEach(weekdayHeaders.indices, id: \.self) { index in
                    Text(weekdayHeaders[index])
                        .font(.bloo(11))
                        .foregroundStyle(BlooTheme.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }

            VStack(spacing: 10) {
                ForEach(weeks, id: \.self) { week in
                    HStack {
                        ForEach(week, id: \.self) { date in
                            Circle()
                                .fill(color(for: state(date)))
                                .frame(width: 12, height: 12)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }

            HStack(spacing: 16) {
                legendItem(state: .completed, label: "Completed")
                legendItem(state: .partial, label: "Partial")
                legendItem(state: .noData, label: "No data")
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

    private func legendItem(state: DayCompletionState, label: String) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color(for: state)).frame(width: 8, height: 8)
            Text(label)
                .font(.bloo(10))
                .foregroundStyle(BlooTheme.secondaryText)
        }
    }
}
