//
//  MovieViewModel.swift
//  Movies
//
//  Created by Douglas Hennrich on 31/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import Foundation

struct MovieViewModel: Codable {
    
    private let movie: Movie
    
    var photo: String {
        return movie.multimedia?.src ?? ""
    }
    
    var title: String {
        return movie.displayTitle
    }
    
    var description: String {
        return movie.summaryShort
    }
    
    var reviewer: String {
        return movie.byline
    }
    
    var favorited: Bool {
        return FavoritesManager.shared.alreadyOnList(self)
    }
    
    // MARK: Init
    init(movie: Movie) {
        self.movie = movie
    }
    
}

extension MovieViewModel: Equatable {
    
    static func == (lhs: MovieViewModel, rhs: MovieViewModel) -> Bool {
        return lhs.title == rhs.title &&
            lhs.reviewer == rhs.reviewer &&
            lhs.description == rhs.description
    }
    
}
