//
//  FavoritesScreen.swift
//  GhibliSwiftUIApp
//
//  Created by Karin Prater on 10/8/25.
//

import SwiftUI

struct FavoritesScreen: View {
    
    let filmsViewModel: FilmsViewModel
    let favoritesViewModel: FavoritesViewModel
    
    var films: [Film] {
       let favorites = favoritesViewModel.favoriteIDs
        switch filmsViewModel.state {
            case .loaded(let films):
                return films.filter { favorites.contains($0.id) }
            default: return []
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if films.isEmpty {
                    ContentUnavailableView("No Favorites yet", systemImage: "heart")
                } else {
                    FilmListView(films: films,
                                 favoritesViewModel: favoritesViewModel)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesScreen(filmsViewModel: FilmsViewModel.example,
                    favoritesViewModel: FavoritesViewModel.example)
}
