//
//  FavoriteStorage.swift
//  GhibliSwiftUIApp
//
//  Created by Karin Prater on 10/8/25.
//

import Foundation

protocol FavoriteStorage {
    func load() -> Set<String>
    func save(favoriteIDs: Set<String>)
}
