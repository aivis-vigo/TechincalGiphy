//
//  ContentView.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 08/01/2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            TrendingView()
            .tabItem {
                Image(systemName: "house.fill")
                Text("Explore")
            }
            SearchView()
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
        }
    }
}

#Preview {
    MainView()
}
