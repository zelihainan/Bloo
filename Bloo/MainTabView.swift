//
//  MainTabView.swift
//  Bloo
//
//  Custom tab bar (not SwiftUI's native TabView chrome) to match Figma exactly:
//  same icon color for every tab, with a 2x2 dot underneath the active one —
//  no pill/tint highlight (node 5:109, icons at y=820, divider at y=809).
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selectedTab {
                case 0: HomeView()
                case 1: ProgressScreenView()
                case 2: CollectionsScreenView()
                default: SettingsScreenView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

private struct CustomTabBar: View {
    @Binding var selectedTab: Int

    private let icons = ["house", "chart.bar.fill", "square.grid.2x2", "gearshape"]

    var body: some View {
        VStack(spacing: 0) {
            Rectangle().fill(BlooTheme.tabBarDivider).frame(height: 1)

            HStack(spacing: 0) {
                ForEach(icons.indices, id: \.self) { index in
                    Spacer()
                    Button {
                        selectedTab = index
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: icons[index])
                                .font(.system(size: 17))
                                .foregroundStyle(BlooTheme.tabIcon)
                                .frame(width: 20, height: 20)
                            Circle()
                                .fill(selectedTab == index ? BlooTheme.tabIcon : .clear)
                                .frame(width: 2, height: 2)
                        }
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
            .padding(.top, 11)
            .padding(.bottom, 8)
        }
        .background(BlooTheme.background)
    }
}
