//
//  FilmsScreen.swift
//  GhibliSwiftUIApp
//
//  Created by Karin Prater on 10/8/25.
//

import SwiftUI

struct FilmsScreen: View {
    
    let filmsViewModel: FilmsViewModel
    let favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                switch filmsViewModel.state {
                    case .idle:
                        Text("No Films yet")
                        
                    case .loading:
                        ProgressView {
                            Text("Loading ...")
                        }
                    case .loaded(let films):
                        FilmListView(films: films,
                                     favoritesViewModel: favoritesViewModel)
                    case .error(let error):
                        Text(error)
                            .foregroundStyle(.pink)
                }
            }
            .navigationTitle("Ghibli Movies")
        }
    }
}

#Preview {
    FilmsScreen(filmsViewModel: FilmsViewModel.example, favoritesViewModel: FavoritesViewModel.example)
}
