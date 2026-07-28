//
//  FavoritesViewModel.swift
//  GhibliSwiftUIApp
//
//  Created by Karin Prater on 10/8/25.
//

import Foundation
import Observation

@Observable
class FavoritesViewModel {
    
    private(set) var favoriteIDs: Set<String> = []
    
    private let service: FavoriteStorage
  
    init( service: FavoriteStorage = DefaultFavoriteStorage()) {
        self.service = service
    }
    
    func load() {
        favoriteIDs = service.load()
    }
    
    private func save() {
        service.save(favoriteIDs: favoriteIDs)
    }
    
    func toggleFavorite(filmID: String) {
        if favoriteIDs.contains(filmID) {
            favoriteIDs.remove(filmID)
        } else {
            favoriteIDs.insert(filmID)
        }
        
        save()
    }
    
    
    func isFavorite(filmID: String) -> Bool {
        favoriteIDs.contains(filmID)
    }
    
    //MARK: - preview
    static var example: FavoritesViewModel {
        let vm = FavoritesViewModel(service: MockFavoriteStorage())
        vm.favoriteIDs = ["2baf70d1-42bb-4437-b551-e5fed5a87abe"]
        
        return vm
    }
    
}
