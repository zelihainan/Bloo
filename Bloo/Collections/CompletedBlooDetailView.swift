//
//  CompletedBlooDetailView.swift
//  Bloo
//
//  A read-only celebration/detail sheet for a Bloo that's already finished
//  growing. Tapping a "Grown up" tile in the Collections grid opens this
//  instead of re-activating it — only one Bloo can be growing (and earning
//  XP) at a time, so a completed one stays a keepsake rather than becoming
//  selectable again. The trophy badge and "Grown up" label live only here —
//  the grid tile itself stays clean until tapped.
//

import SwiftUI

struct CompletedBlooDetailView: View {
    let bloo: Bloo

    @Environment(\.dismiss) private var dismiss

    private var accentColor: Color { Color(hex: bloo.species.colorHex) }
    private var backdropColor: Color { Color.pastel(hex: bloo.species.colorHex) }

    private var growthDurationDays: Int? {
        guard let activatedAt = bloo.activatedAt, let completedAt = bloo.completedAt else { return nil }
        return Calendar.current.dateComponents([.day], from: activatedAt, to: completedAt).day
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.bloo(13, weight: .semibold))
                        .foregroundStyle(BlooTheme.secondaryText)
                        .frame(width: 32, height: 32)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .buttonStyle(.pressable)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)

            Spacer()

            ZStack {
                Circle()
                    .fill(backdropColor)
                    .frame(width: 210, height: 210)
                BlooArtworkView(species: bloo.species, showsBackdrop: false)
                    .frame(width: 178, height: 178)

                ZStack {
                    Circle().fill(Color(hex: "#FFB020")).frame(width: 42, height: 42)
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                }
                .overlay(Circle().stroke(BlooTheme.background, lineWidth: 3))
                .offset(x: 72, y: 72)
            }
            .padding(.bottom, 20)

            Text(bloo.displayName)
                .font(.bloo(26, weight: .bold))
                .foregroundStyle(BlooTheme.primaryText)

            Text("Fully grown")
                .font(.bloo(14, weight: .semibold))
                .foregroundStyle(accentColor)
                .padding(.top, 2)

            if growthDurationDays != nil || bloo.completedAt != nil {
                VStack(spacing: 0) {
                    if let completedAt = bloo.completedAt {
                        statRow(label: "Grown on", value: completedAt.formatted(date: .abbreviated, time: .omitted))
                        if growthDurationDays != nil { divider }
                    }
                    if let days = growthDurationDays {
                        statRow(label: "Time to grow", value: dayCountLabel(days))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: BlooTheme.secondaryCardCornerRadius, style: .continuous)
                        .stroke(BlooTheme.cardBorder, lineWidth: 1)
                )
                .padding(.horizontal, 32)
                .padding(.top, 24)
            }

            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlooTheme.background)
        .environment(\.blooAccentColor, accentColor)
    }

    private var divider: some View {
        Rectangle().fill(BlooTheme.cardBorder).frame(height: 1)
    }

    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(LocalizedStringKey(label))
                .font(.bloo(13))
                .foregroundStyle(BlooTheme.secondaryText)
            Spacer()
            Text(value)
                .font(.bloo(13, weight: .semibold))
                .foregroundStyle(BlooTheme.primaryText)
        }
        .padding(.vertical, 12)
    }

    private func dayCountLabel(_ days: Int) -> String {
        let format = days == 1 ? NSLocalizedString("%d Day", comment: "") : NSLocalizedString("%d Days", comment: "")
        return String(format: format, days)
    }
}
