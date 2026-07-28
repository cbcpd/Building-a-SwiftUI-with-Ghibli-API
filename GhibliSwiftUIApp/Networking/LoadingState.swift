//
//  LoadingState.swift
//  GhibliSwiftUIApp
//
//  Created by Karin Prater on 10/8/25.
//


import Foundation

enum LoadingState<T: Equatable>: Equatable {
    case idle
    case loading
    case loaded(T)
    case error(String)
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var data: T? {
        if case .loaded(let value) = self { return value }
        return nil
    }
    
    var error: String? {
        if case .error(let message) = self { return message }
        return nil
    }
}
