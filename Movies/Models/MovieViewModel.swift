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
    private var dateFormatterGet: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
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
    
    var headline: String {
        return movie.headline
    }
    
    var favorited: Bool {
        return FavoritesManager.shared.alreadyOnList(self)
    }
    
    var link: String {
        return movie.link.url
    }
    
    var linkDescription: String {
        return movie.link.suggestedLinkText
    }
    
    var publicDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        guard let date = dateFormatterGet.date(from: movie.publicationDate)
            else {
                return "--"
        }
        
        return formatter.string(from: date)
    }
    
    var updatedDate: String {
        let updatedDateFormatterGet = DateFormatter()
        updatedDateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        guard let fromMovie = movie.dateUpdated,
            let date = updatedDateFormatterGet.date(from: fromMovie)
            else {
                return "--"
        }
        
        return formatter.string(from: date)
    }
    
    var openingDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        guard let fromMovie = movie.openingDate,
            let date = dateFormatterGet.date(from: fromMovie)
            else {
                return "--"
        }
        
        return formatter.string(from: date)
    }
    
    var rate: String? {
        return movie.mpaaRating.rawValue
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
