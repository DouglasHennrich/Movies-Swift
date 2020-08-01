//
//  HomeViewModelTest.swift
//  MoviesTests
//
//  Created by Douglas Hennrich on 01/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import XCTest
@testable import Movies

// swiftlint:disable force_cast
class HomeViewModelTest: HomeViewModelDelegate {
    
    // MARK: Properties
    private let service: HomeServiceDelegate
    private var offset: Int = 0
    private var firstRequest: Bool = true
    private let numberOfHighlights: Int = 1
    var expectation: XCTestExpectation
    var apiShouldFail: Bool = false
    
    var loading: Binder<(actived: Bool, message: String?)> = Binder((false, nil))
    var error: Binder<String> = Binder("")
    var movies: Binder<[MovieViewModel]> = Binder([])
    
    var highlights: [MovieViewModel] = []
    
    // MARK: Init
    init(service: HomeServiceDelegate = HomeServiceTest(),
         expectation: XCTestExpectation) {
        self.service = service
        self.expectation = expectation
    }
    
    // MARK: Actions
    func getMovie(on section: Int, at: Int) -> MovieViewModel? {
        if section == 0 {
            return highlights.at(at)
        }
        
        return movies.value.at(at)
    }
    
    //
    func moviesCount() -> Int {
        return movies.value.count
    }
    
    //
    func highlightsCount() -> Int {
        return highlights.count
    }
    
    //
    func getMovies(fromRefresh: Bool) {
        if fromRefresh {
            offset = 0
            firstRequest = true
            highlights = []
            movies.value = []
        }
        
        loading.value = (true, "Buscando filmes")
        
        if apiShouldFail {
            (service as! HomeServiceTest).shouldFail = true
        }
        
        service.getMovies(offset: offset,
                          order: .openingDate) { [weak self] result in
                            guard let self = self else { return }
                            self.loading.value = (false, nil)
                            
                            switch result {
                            case .success(let moviesManager):
                                self.offset += moviesManager.numResults
                                
                                let (getHighlights, getNewMovies) = UsefulFunctions
                                    .separeteHighlightsFromMovies(
                                        for: self.firstRequest ? self.numberOfHighlights : 0,
                                        with: moviesManager.results)
                                
                                if self.firstRequest {
                                    self.firstRequest = false
                                }
                                
                                self.highlights = getHighlights
                                self.movies.value = getNewMovies
                                
                                self.expectation.fulfill()
                                
                            case .failure(let error):
                                guard let error = error as? ServiceError else {
                                    return
                                }
                                
                                self.error.value = error.message
                                self.expectation.fulfill()
                            }
        }
    }
    
    //
    func openMovie(on section: Int, at row: Int) {}
        
}
