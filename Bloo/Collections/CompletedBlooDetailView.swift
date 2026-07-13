//
//  CompletedBlooDetailView.swift
//  Bloo
//
//  A read-only celebration/detail sheet for a Bloo that's already finished
//  growing. Tapping a "Grown up" tile in the Collections grid opens this
//  instead of re-activating it — only one Bloo can be growing (and earning
//  XP) at a time, so a completed one stays a keepsake rather than becoming
//  selectable again.
//

import SwiftUI

struct CompletedBlooDetailView: View {
    let bloo: Bloo

    @Environment(\.dismiss) private var dismiss

    private var accentColor: Color { Color(hex: bloo.species.colorHex) }
    private var backdropColor: Color { Color.pastel(hex: bloo.species.colorHex) }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.bloo(14, weight: .semibold))
                        .foregroundStyle(BlooTheme.secondaryText)
                        .padding(8)
                }
                .buttonStyle(.pressable)
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(backdropColor)
                    .frame(width: 190, height: 190)
                BlooArtworkView(species: bloo.species, showsBackdrop: false)
                    .frame(width: 160, height: 160)
            }

            VStack(spacing: 6) {
                Text(bloo.displayName)
                    .font(.bloo(24, weight: .semibold))
                    .foregroundStyle(BlooTheme.primaryText)

                HStack(spacing: 4) {
                    Image(systemName: "trophy.fill")
                        .foregroundStyle(Color(hex: "#FFB020"))
                    Text("Grown up")
                        .font(.bloo(14, weight: .medium))
                        .foregroundStyle(BlooTheme.secondaryText)
                }

                if let completedAt = bloo.completedAt {
                    Text(completedAt, style: .date)
                        .font(.bloo(12))
                        .foregroundStyle(BlooTheme.tertiaryText)
                }
            }

            Spacer()
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlooTheme.background)
        .environment(\.blooAccentColor, accentColor)
    }
}
