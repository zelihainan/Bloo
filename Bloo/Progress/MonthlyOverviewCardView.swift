import SwiftUI

enum DayCompletionState {
    case completed, partial, noData
}

struct MonthlyOverviewCardView: View {
    let weeks: [[Date]]
    let state: (Date) -> DayCompletionState
    let accentColor: Color

    private let weekdayHeaders = Weekday.allCases.map(\.shortLabel)

    private func color(for state: DayCompletionState) -> Color {
        switch state {
        case .completed: accentColor.mixed(withBlack: 0.3)
        case .partial: accentColor.mixed(withWhite: 0.55)
        case .noData: RateColorScale.noData
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Monthly overview")
                .font(.bloo(15, weight: .medium))
                .foregroundStyle(BlooTheme.secondaryText)

            HStack(spacing: 0) {
                ForEach(weekdayHeaders.indices, id: \.self) { index in
                    Text(LocalizedStringKey(weekdayHeaders[index]))
                        .font(.bloo(9, weight: .medium))
                        .foregroundStyle(BlooTheme.tertiaryText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .frame(maxWidth: .infinity)
                }
            }

            VStack(spacing: 6) {
                ForEach(weeks, id: \.self) { week in
                    HStack(spacing: 0) {
                        ForEach(week, id: \.self) { date in
                            Circle()
                                .fill(color(for: state(date)))
                                .frame(width: 12, height: 12)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                legendItem(state: .completed, label: "Completed")
                legendItem(state: .partial, label: "Partial")
                legendItem(state: .noData, label: "No data")
            }
            .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(13)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }

    private func legendItem(state: DayCompletionState, label: String) -> some View {
        HStack(spacing: 5) {
            Circle().fill(color(for: state)).frame(width: 8, height: 8)
            Text(LocalizedStringKey(label))
                .font(.bloo(10))
                .foregroundStyle(BlooTheme.secondaryText)
        }
    }
}
