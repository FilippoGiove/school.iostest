//
//  TabbedBar.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import SwiftUI

struct TabbedBar: View {

    @State private var selectedTabIndex = 0

    var body: some View {

        TabView(selection: $selectedTabIndex) {
                    HomeView()
                        .tabItem {
                            Label("", systemImage: "house")
                        }
                        .tag(0)
                    SearchView()
                    .tabItem {
                        Label("", systemImage: "magnifyingglass")
                    }
                .tag(1)
                    SettingsView()
                        .tabItem {
                            Label("", systemImage: "gearshape")
                        }
                        .tag(1)
                }
        .toolbarColorScheme(.light, for: .tabBar)

    }
}

