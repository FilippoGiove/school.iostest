//
//  TabbedBar.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import SwiftUI

struct TabbedBar: View {

    @State private var selectedTabIndex = 0
    init() {
        UITabBar.appearance().backgroundColor = UIColor.black.withAlphaComponent(20)
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray

    }
    var body: some View {

        TabView(selection: $selectedTabIndex) {
                    HomeView()
                        .tabItem {
                            Label("HOME".localized, systemImage: "house")
                        }
                        .tag(0)
                    SearchView()
                    .tabItem {
                        Label("SEARCH".localized, systemImage: "magnifyingglass")
                    }
                .tag(1)
                    SettingsView()
                        .tabItem {
                            Label("SETTINGS".localized, systemImage: "gearshape")
                        }
                        .tag(2)
                }
        .toolbar(.visible, for: .tabBar)
        //.toolbarColorScheme(.light, for: .tabBar)
        //.toolbarBackground(Color.black.opacity(80), for: .tabBar)

    }
}

