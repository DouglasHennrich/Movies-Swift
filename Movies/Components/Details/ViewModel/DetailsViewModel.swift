//
//  DetailsViewModel.swift
//  Movies
//
//  Created by Douglas Hennrich on 02/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import Foundation

// MARK: Delegate
protocol DetailsViewModelDelegate: AnyObject {
    var navTitle: String { get }
    var favorited: Binder<Bool> { get }
    
    func getPhoto() -> String
    func getSectionsCount() -> Int
    func getIem(on section: Int, at index: Int) -> (type: MovieDetailsTypes, data: [String: Any])?
    func onFavoritePressed()
    func getLink() -> URL?
}

// MARK: ViewModel
class DetailsViewModel {
    
    // MARK: Properties
    private lazy var logger: Logger = Logger.forClass(Self.self)
    private let favoriteManager = FavoritesManager.shared
    private var movieInfos: [SectionsAndItemsDetails] = []
    
    var favorited: Binder<Bool> = Binder(false)
    
    var movie: MovieViewModel
    var navTitle: String
    
    // MARK: Init
    init(movie: MovieViewModel) {
        self.movie = movie
        
        navTitle = movie.title
        
        favorited.value = movie.favorited
        
        setInfo()
    }
    
    // MARK: Actions
    private func setInfo() {
        
        // Title & Description
        var typeAndDescription = SectionsAndItemsDetails(type: .typeAndDescription)
        typeAndDescription.data.append([
            "firstLabelKey": "Título",
            "firstLabelValue": movie.title,
            "secondLabelKey": "Descrição",
            "secondLabelValue": movie.description
        ])
        movieInfos.append(typeAndDescription)
        
        // Reviewer & Headline
        var reviewerAndHeadline = SectionsAndItemsDetails(type: .reviewerAndHeadline)
        reviewerAndHeadline.data.append([
            "firstLabelKey": "Reviewer",
            "firstLabelValue": movie.reviewer,
            "secondLabelKey": "Headline",
            "secondLabelValue": movie.headline
        ])
        movieInfos.append(reviewerAndHeadline)
        
        // Date & Rate
        var dateAndRating = SectionsAndItemsDetails(type: .dateAndRating)
        dateAndRating.data.append([
            "openingDate": movie.openingDate,
            "publicDate": movie.publicDate,
            "updatedDate": movie.updatedDate,
            "rate": movie.rate as Any
        ])
        movieInfos.append(dateAndRating)
        
        // Link
        var link = SectionsAndItemsDetails(type: .link)
        link.data.append([
            "link": movie.link,
            "description": movie.linkDescription
        ])
        movieInfos.append(link)
        
    }

    private func favorite(action: FavoritesManager.FavoritesActions) {
        if action == .save {
            favoriteManager.save(movie)
            favorited.value = true
        } else if action == .remove {
            favoriteManager.remove(movie)
            favorited.value = false
        }
    }
}

// MARK: Extension
extension DetailsViewModel: DetailsViewModelDelegate {
    
    func getPhoto() -> String {
        return movie.photo
    }
    
    func getSectionsCount() -> Int {
        return movieInfos.count
    }
    
    func getIem(on section: Int, at index: Int) -> (type: MovieDetailsTypes, data: [String: Any])? {
        guard let currentSection = movieInfos.at(section),
            let currentData = currentSection.data.first
            else {
                return nil
        }
        
        return (type: currentSection.type, data: currentData)
    }
    
    func getLink() -> URL? {
        return URL(string: movie.link)
    }
    
    func onFavoritePressed() {
        favorite(action: movie.favorited ? .remove : .save)
    }
    
}
