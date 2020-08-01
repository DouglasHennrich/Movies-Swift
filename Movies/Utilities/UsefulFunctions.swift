//
//  UsefulFunctions.swift
//  Movies
//
//  Created by Douglas Hennrich on 01/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

struct UsefulFunctions {
    
    static func separeteHighlightsFromMovies(for howMany: Int,
                                             with movies: [Movie]) ->
        (hightlights: [MovieViewModel],
        movies: [MovieViewModel]) {
        
        var highlights: [MovieViewModel] = []
        var newMovies: [MovieViewModel] = []
        
        for (index, movie) in movies.enumerated() {
            if index <= howMany {
                highlights.append(MovieViewModel(movie: movie))
            } else {
                newMovies.append(MovieViewModel(movie: movie))
            }
        }
        
        return (highlights, newMovies)
    }
    
}
