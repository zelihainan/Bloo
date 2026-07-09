//
//  MainTabView.swift
//  Bloo
//

import SwiftUI

/// Home / Progress / Collections / Settings tab bar. Settings is still a
/// lightweight placeholder until its milestone.
struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            ProgressScreenView()
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }

            CollectionsScreenView()
                .tabItem { Label("Collections", systemImage: "square.grid.2x2.fill") }

            PlaceholderTabView(title: "Settings")
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
    }
}

private struct PlaceholderTabView: View {
    let title: String

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.bloo(28, weight: .semibold))
            Text("Coming soon")
                .font(.bloo(15))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlooTheme.background)
    }
}
