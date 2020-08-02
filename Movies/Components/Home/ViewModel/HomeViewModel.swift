//
//  HomeViewModel.swift
//  Movies
//
//  Created by Douglas Hennrich on 28/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import Foundation

// MARK: Delegate
protocol HomeViewModelDelegate: AnyObject {
    var loading: Binder<(actived: Bool, message: String?)> { get }
    var error: Binder<String> { get }
    var movies: Binder<[MovieViewModel]> { get }
    var search: Binder<[MovieViewModel]> { get }
    var noMoreData: Binder<Bool> { get }
    var highlights: [MovieViewModel] { get }
    
    func highlightsCount() -> Int
    func moviesCount() -> Int
    func getMovies(fromRefresh: Bool)
    func loadMore()
    func getMovie(on section: Int, at: Int) -> MovieViewModel?
    func openMovie(on section: Int, at row: Int)
    func resetSearch()
    func searchMovies(for movie: String)
}

// MARK: ViewModel
class HomeViewModel {
    
    // MARK: Properties
    private lazy var logger: Logger = Logger.forClass(Self.self)
    private var navigation: HomeCoordinatorDelegate?
    private let service: HomeServiceDelegate
    
    private var offset: Int = 0
    private var firstRequest: Bool = true
    private let numberOfHighlights: Int = 5
    
    var loading: Binder<(actived: Bool, message: String?)> = Binder((false, nil))
    var error: Binder<String> = Binder("")
    var movies: Binder<[MovieViewModel]> = Binder([])
    var search: Binder<[MovieViewModel]> = Binder([])
    var noMoreData: Binder<Bool> = Binder(false)
    var highlights: [MovieViewModel] = []
    
    // MARK: Init
    init(navigation: HomeCoordinatorDelegate?,
         service: HomeServiceDelegate = HomeService()) {
        self.navigation = navigation
        self.service = service
    }
    
    // MARK: Actions
    private func requestMovies(loadMore: Bool = false) {
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
                                
                                if !moviesManager.hasMore {
                                    self.noMoreData.value = true
                                }
                                
                                if loadMore {
                                    self.movies.value.append(contentsOf: getNewMovies)
                                    
                                } else {
                                    self.highlights = getHighlights
                                    self.movies.value = getNewMovies
                                }
                                
                            case .failure(let error):
                                guard let error = error as? ServiceError else {
                                    return
                                }
                                
                                self.error.value = error.message
                            }
        }
    }
}

// MARK: Extension
extension HomeViewModel: HomeViewModelDelegate {
    
    //
    func getMovie(on section: Int, at: Int) -> MovieViewModel? {
        if search.value.count > 0 {
            return search.value.at(at)
        }
        
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
            search.value = []
            noMoreData.value = false
        }
        
        loading.value = (true, "Buscando filmes")
        requestMovies()
    }
    
    //
    func openMovie(on section: Int, at row: Int) {
        guard let movie = getMovie(on: section, at: row)
            else {
                return
        }
        
        navigation?.openMovieDetails(with: movie)
    }
    
    //
    func resetSearch() {
        search.value = []
        movies.fire()
    }
    
    //
    func searchMovies(for movie: String) {
        loading.value = (true, nil)
        service.searchMovies(by: movie) { [weak self] result in
            guard let self = self else { return }
            self.loading.value = (false, nil)
            switch result {
            case .success(let moviesManager):
                let (_, foundedMovies) = UsefulFunctions
                    .separeteHighlightsFromMovies(
                        for: 0,
                        with: moviesManager.results)
                
                self.search.value = foundedMovies
                
            case .failure(let error):
                guard let error = error as? ServiceError else {
                    return
                }
                self.noMoreData.value = true
                self.error.value = error.message
            }
        }
    }
    
    //
    func loadMore() {
        requestMovies(loadMore: true)
    }
}
