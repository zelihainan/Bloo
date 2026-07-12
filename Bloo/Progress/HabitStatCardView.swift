//
//  HabitStatCardView.swift
//  Bloo
//
//  A single "Best habit" / "Needs attention" stat card — stacked vertically
//  next to Monthly overview, rather than side by side.
//

import SwiftUI

struct HabitStatCardView: View {
    let title: String
    let habitName: String
    let days: Int
    let valueColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(LocalizedStringKey(title))
                .font(.bloo(12))
                .foregroundStyle(BlooTheme.secondaryText)
            Text(habitName)
                .font(.bloo(15, weight: .medium))
                .foregroundStyle(BlooTheme.primaryText)
                .lineLimit(1)
            Text(dayCountLabel(days))
                .font(.bloo(14, weight: .medium))
                .foregroundStyle(valueColor)
        }
        .frame(maxWidth: .infinity, minHeight: 90, alignment: .topLeading)
        .padding(13)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }

    private func dayCountLabel(_ days: Int) -> String {
        let format = days == 1 ? NSLocalizedString("%d Day", comment: "") : NSLocalizedString("%d Days", comment: "")
        return String(format: format, days)
    }
}
