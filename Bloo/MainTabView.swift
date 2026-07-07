//
//  MainTabView.swift
//  Bloo
//

import SwiftUI

/// Home / Progress / Collections / Settings tab bar. Collections and Settings
/// are still lightweight placeholders until their milestones.
struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            ProgressScreenView()
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }

            PlaceholderTabView(title: "Collections")
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
                .font(.system(size: 28, weight: .semibold))
            Text("Coming soon")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlooTheme.background)
    }
}
