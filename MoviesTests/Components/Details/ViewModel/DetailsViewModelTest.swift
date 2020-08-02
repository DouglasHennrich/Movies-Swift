//
//  DetailsViewModelTest.swift
//  MoviesTests
//
//  Created by Douglas Hennrich on 02/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import XCTest
@testable import Movies

class DetailsViewModelTest: DetailsViewModelDelegate {
    
    // MARK: Properties
    private var movieInfos: [SectionsAndItemsDetails] = []
    private let favoriteManager = FavoritesManager.shared
    
    var expectation: XCTestExpectation
    var apiShouldFail: Bool = false
    
    var movie: MovieViewModel
    var navTitle: String
    
    var favorited: Binder<Bool> = Binder(false)
    
    // MARK: Init
    init(movie: MovieViewModel,
         expectation: XCTestExpectation) {
        self.movie = movie
        self.expectation = expectation
        
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
        
        //
        self.expectation.fulfill()
    }

    private func favorite(action: FavoritesManager.FavoritesActions) {
        if action == .save {
             favoriteManager.test_save(movie)
            favorited.value = true
        } else if action == .remove {
             favoriteManager.test_remove(movie)
            favorited.value = false
        }
        
        expectation.fulfill()
    }
    
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
    
    func getSectionIndex(ofType type: MovieDetailsTypes) -> Int {
        let index = movieInfos.firstIndex { $0.type == type }
        return index ?? 0
    }

}
