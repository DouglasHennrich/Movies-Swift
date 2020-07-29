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
    var movies: Binder<[Movie]> { get }
    
    subscript(on section: Int, at: Int) -> Movie? { get }
    
    func moviesCount() -> Int
    func getMovies()
}

// MARK: ViewModel
class HomeViewModel {
    
    // MARK: Properties
    private lazy var logger: Logger = Logger.forClass(Self.self)
    private var navigation: HomeCoordinatorDelegate?
    private let service: HomeServiceDelegate
    
    private var moviesManager: Movies?
    
    var loading: Binder<(actived: Bool, message: String?)> = Binder((false, nil))
    var error: Binder<String> = Binder("")
    var movies: Binder<[Movie]> = Binder([])
    
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
    
    subscript(on section: Int, at: Int) -> Movie? {
        return movies.value.at(at)
    }
    
    //
    func moviesCount() -> Int {
        return movies.value.count
    }
    
    //
    func getMovies() {
        loading.value = (true, "Buscando filmes")
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] timer in
            timer.invalidate()
            self?.movies.value = []
            self?.loading.value = (false, nil)
        }
    }
    
}
