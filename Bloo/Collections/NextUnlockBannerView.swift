//
//  NextUnlockBannerView.swift
//  Bloo
//
//  Values from the Figma REST API (node 16:15): card radius14 size(335,64),
//  55x55 portrait, title 13px semibold, subtitle 9px SEMIBOLD (not regular)
//  #B0A898, progress bar height4 filled BLACK (not accent), 15x15 lock badge.
//

import SwiftUI

/// "Next unlock!" banner: the next locked species, with progress toward it
/// driven by how close the active Bloo is to finishing its growth (since
/// unlocking is purely sequential — see BlooSpecies.next).
struct NextUnlockBannerView: View {
    let nextLockedBloo: Bloo
    let activeBloo: Bloo?

    var body: some View {
        HStack(spacing: 13) {
            BlooArtworkView(species: nextLockedBloo.species, isLocked: true, showsBackdrop: false)
                .frame(width: 55, height: 55)

            VStack(alignment: .leading, spacing: 4) {
                Text("Next unlock!")
                    .font(.bloo(15, weight: .semibold))
                    .foregroundStyle(BlooTheme.primaryText)
                Text(String(format: NSLocalizedString("Help %@ finish growing to unlock", comment: ""), activeBloo?.displayName ?? "your Bloo"))
                    .font(.bloo(11, weight: .medium))
                    .foregroundStyle(BlooTheme.tertiaryText)
                    .lineLimit(2)
            }

            Spacer(minLength: 8)

            ZStack {
                Circle().fill(BlooTheme.cardBorder).frame(width: 15, height: 15)
                Image(systemName: "lock.fill")
                    .font(.system(size: 7))
                    .foregroundStyle(BlooTheme.secondaryText)
            }
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
}
