//
//  FavoritesManager.swift
//  Movies
//
//  Created by Douglas Hennrich on 01/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import Foundation

class FavoritesManager {
    
    // MARK: Enum
    enum FavotitesEnum: String {
        case list = "favoritesList"
    }
    
    enum FavoritesActions {
        case save
        case remove
    }
    
    // MARK: Shared
    static let shared: FavoritesManager = FavoritesManager()
    
    // MARK: Properties
    private lazy var logger: Logger = Logger.forClass(Self.self)
    private let defaults = UserDefaults.standard
    var favorites: [MovieViewModel] = []
    
    // MARK: Init
    private init() {
        guard let data = defaults.value(forKey: FavotitesEnum.list.rawValue) as? Data,
            let favorites = try? JSONDecoder().decode([MovieViewModel].self, from: data)
            else {
                return
        }
        
        self.favorites = favorites
    }
    
    // MARK: Actions
    private func saveToDefaults() {
        if let data = try? JSONEncoder().encode(favorites) {
            defaults.set(data, forKey: FavotitesEnum.list.rawValue)
        } else {
            print("cant save")
        }
    }
    
    func alreadyOnList(_ movie: MovieViewModel) -> Bool {
        return favorites.first { $0 == movie } != nil
    }
    
    func save(_ movie: MovieViewModel) {
        if alreadyOnList(movie) { return }
        
        favorites.append(movie)
        saveToDefaults()
    }
    
    func remove(_ movie: MovieViewModel) {
        favorites.removeAll { $0 == movie }
        saveToDefaults()
    }
    
}
