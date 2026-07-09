//
//  NextUnlockBannerView.swift
//  Bloo
//

import SwiftUI

/// "Next unlock!" banner: the next locked species, with progress toward it
/// driven by how close the active Bloo is to finishing its growth (since
/// unlocking is purely sequential — see BlooSpecies.next).
struct NextUnlockBannerView: View {
    let nextLockedBloo: Bloo
    let activeBloo: Bloo?

    private var progress: Double { activeBloo?.stageProgress ?? 0 }

    var body: some View {
        HStack(spacing: 16) {
            BlooArtworkView(species: nextLockedBloo.species, isLocked: true, showsBackdrop: false)
                .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 6) {
                Text("Next unlock!")
                    .font(.bloo(16, weight: .semibold))
                Text("Help \(activeBloo?.displayName ?? "your Bloo") finish growing to unlock")
                    .font(.bloo(13))
                    .foregroundStyle(.secondary)

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.gray.opacity(0.15))
                        Capsule()
                            .fill(Color.black)
                            .frame(width: proxy.size.width * progress)
                    }
                }
                .frame(height: 6)
            }

            Image(systemName: "lock.fill")
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: BlooTheme.cardCornerRadius, style: .continuous)
                .stroke(BlooTheme.cardBorder, lineWidth: 1)
        )
    }
}

