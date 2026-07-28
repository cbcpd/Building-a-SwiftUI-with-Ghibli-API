//
//  ContentView.swift
//  GhibliSwiftUIApp
//
//  Created by Karin Prater on 10/6/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var filmsViewModel = FilmsViewModel()
    @State private var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        TabView {
            Tab("Movies", systemImage: "movieclapper") {
                FilmsScreen(filmsViewModel: filmsViewModel,
                            favoritesViewModel: favoritesViewModel)
            }
            
            Tab("Favorites", systemImage: "heart") {
                FavoritesScreen(filmsViewModel: filmsViewModel,
                                favoritesViewModel: favoritesViewModel)
            }
            
            Tab("Settings", systemImage: "gear") {
                SettingsScreen()
            }
            
            Tab(role: .search) {
                SearchScreen(favoritesViewModel: favoritesViewModel)
            }
        }
        .task {
            favoritesViewModel.load()
            await filmsViewModel.fetch()
        }
        .setAppearanceTheme()
    }
}

#Preview {
    ContentView()
}
