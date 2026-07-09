//
//  CollectionsScreenView.swift
//  Bloo
//

import SwiftUI
import SwiftData

struct CollectionsScreenView: View {
    @Query private var bloos: [Bloo]
    @Query private var badges: [Badge]

    private var activeBloo: Bloo? { bloos.first { $0.state == .active } }

    private var nextLockedBloo: Bloo? {
        bloos.filter { $0.state == .locked }.min { $0.speciesRawValue < $1.speciesRawValue }
    }

    private var earnedBadgeTypes: Set<BadgeType> {
        Set(badges.map(\.type))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                BloosGridCardView(bloos: bloos)

                if let nextLockedBloo {
                    NextUnlockBannerView(nextLockedBloo: nextLockedBloo, activeBloo: activeBloo)
                }

                BadgesCardView(earnedTypes: earnedBadgeTypes)
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            .padding(.bottom, 24)
        }
        .background(BlooTheme.background)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Collections")
                .font(.bloo(32, weight: .semibold))
            Text("Meet your Bloos!")
                .font(.bloo(15))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
