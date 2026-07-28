//
//  DefaultFavoriteStorage.swift
//  GhibliSwiftUIApp
//
//  Created by Karin Prater on 10/8/25.
//

import Foundation

struct DefaultFavoriteStorage: FavoriteStorage {
    
    private let favoritesKey = "GhibliExplorer.FavoriteFilms"
    
    func load() -> Set<String> {
        let array = UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
         return Set(array)
    }
    
    func save(favoriteIDs: Set<String>) {
        UserDefaults.standard.set(Array(favoriteIDs), forKey: favoritesKey)
    }
}
