//
//  CollectionsScreenView.swift
//  Bloo
//
//  Header values from the Figma REST API (node 16:15): title 28px REGULAR
//  weight (not semibold) at (51.5,47.5), subtitle 13px #8A8278 at (52,90).
//

import SwiftUI
import SwiftData

struct CollectionsScreenView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var bloos: [Bloo]
    @Query private var badges: [Badge]

    @State private var viewedCompletedBloo: Bloo?

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

                BloosGridCardView(bloos: bloos, onSelect: selectActive, onViewCompleted: { viewedCompletedBloo = $0 })
                    .padding(.horizontal, 28)

                if let nextLockedBloo {
                    NextUnlockBannerView(nextLockedBloo: nextLockedBloo, activeBloo: activeBloo)
                        .padding(.horizontal, 28)
                }

                BadgesCardView(earnedTypes: earnedBadgeTypes)
                    .padding(.horizontal, 28)
            }
            .padding(.bottom, 24)
        }
        .background(BlooTheme.background)
        .sheet(item: $viewedCompletedBloo) { bloo in
            CompletedBlooDetailView(bloo: bloo)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Collections")
                .font(.bloo(28))
                .foregroundStyle(BlooTheme.primaryText)
            Text("Meet your Bloos!")
                .font(.bloo(13))
                .foregroundStyle(BlooTheme.secondaryText)
        }
        .padding(.leading, 28)
        .padding(.top, 47.5)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Switching the active companion from Collections: the previous active
    /// Bloo pauses (keeps its XP, goes back to just "unlocked"), the tapped one
    /// becomes active — which cascades everywhere else via the `state == "active"`
    /// query (Home's portrait, the app-wide accent color, etc).
    private func selectActive(_ bloo: Bloo) {
        guard bloo.state == .unlocked else { return }
        if let activeBloo, activeBloo.id != bloo.id {
            activeBloo.state = .unlocked
        }
        bloo.state = .active
        bloo.activatedAt = Date()
        modelContext.saveAndLogErrors()
    }
}
