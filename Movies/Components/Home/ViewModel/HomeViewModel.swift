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
    var highlights: [MovieViewModel] { get }
    
    func highlightsCount() -> Int
    func moviesCount() -> Int
    func getMovies(fromRefresh: Bool)
    func getMovie(on section: Int, at: Int) -> MovieViewModel?
    func openMovie(on section: Int, at row: Int)
}

// MARK: ViewModel
class HomeViewModel {
    
    // MARK: Properties
    private lazy var logger: Logger = Logger.forClass(Self.self)
    private var navigation: HomeCoordinatorDelegate?
    private let service: HomeServiceDelegate
    
    private var offset: Int = 0
    
    var loading: Binder<(actived: Bool, message: String?)> = Binder((false, nil))
    var error: Binder<String> = Binder("")
    var movies: Binder<[MovieViewModel]> = Binder([])
    var highlights: [MovieViewModel] = []
    
    private var firstRequest: Bool = true
    
    // MARK: Init
    init(navigation: HomeCoordinatorDelegate?,
         service: HomeServiceDelegate = HomeService()) {
        self.navigation = navigation
        self.service = service
    }
    
    // MARK: Actions
    
}

// MARK: Extension
extension HomeViewModel: HomeViewModelDelegate {
    
    //
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
        
        service.getMovies(offset: offset,
                          order: .openingDate) { [weak self] result in
                            guard let self = self else { return }
                            self.loading.value = (false, nil)
                            
                            switch result {
                            case .success(let moviesManager):
                                self.offset += moviesManager.numResults
                                var movies = moviesManager.results
                                
                                if self.firstRequest {
                                    self.firstRequest = false
                                    
                                    let getFirst5 = Array(movies.prefix(5))
                                    movies = Array(movies.dropFirst(5))
                                    
                                    self.highlights = getFirst5.map { MovieViewModel(movie: $0) }
                                }
                                
                                self.movies.value = movies.map { MovieViewModel(movie: $0) }
                                
                            case .failure(let error):
                                guard let error = error as? ServiceError else {
                                    return
                                }
                                
                                self.error.value = error.message
                            }
        }
    }
    
    //
    func openMovie(on section: Int, at row: Int) {
        guard let movie = section == 0 ?
            highlights.at(row) : movies.value.at(row)
            else {
                return
        }
        
        navigation?.openMovieDetails(with: movie)
    }
    
}
