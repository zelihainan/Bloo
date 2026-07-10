//
//  MainTabView.swift
//  Bloo
//
//  Native TabView — renders iOS 26's default Liquid Glass tab bar automatically.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            ProgressScreenView()
                .tabItem { Label("Progress", systemImage: "chart.line.uptrend.xyaxis") }

            CollectionsScreenView()
                .tabItem { Label("Collections", systemImage: "pawprint.fill") }

            SettingsScreenView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
    }
}
