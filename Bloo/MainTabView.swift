//
//  MainTabView.swift
//  Bloo
//

import SwiftUI

/// Home / Progress / Collections / Settings tab bar.
struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            ProgressScreenView()
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }

            CollectionsScreenView()
                .tabItem { Label("Collections", systemImage: "square.grid.2x2.fill") }

            SettingsScreenView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
    }
}
