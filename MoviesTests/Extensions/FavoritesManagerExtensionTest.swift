//
//  FavoritesManagerExtensionTest.swift
//  MoviesTests
//
//  Created by Douglas Hennrich on 02/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

@testable import Movies
import Foundation

extension FavoritesManager {
    
    func setUpTestList() {
        let defaults = UserDefaults.standard
        
        guard let data = defaults.value(forKey: "favoritesListTest") as? Data,
            let favorites = try? JSONDecoder().decode([MovieViewModel].self, from: data)
            else {
                self.favorites = []
                return
        }
        
        self.favorites = favorites
    }
    
    func tearDownTestList() {
        UserDefaults.standard.removeObject(forKey: "favoritesListTest")
        self.favorites.removeAll()
    }
    
    private func test_saveToDefaults() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: "favoritesListTest")
        } else {
            fatalError()
        }
    }
    
    func test_save(_ movie: MovieViewModel) {
        if alreadyOnList(movie) { return }
        
        favorites.append(movie)
        test_saveToDefaults()
    }
    
    func test_remove(_ movie: MovieViewModel) {
        favorites.removeAll { $0 == movie }
        test_saveToDefaults()
    }
    
}
