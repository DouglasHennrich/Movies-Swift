//
//  HomeCoordinator.swift
//  Movies
//
//  Created by Douglas Hennrich on 28/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import Foundation

protocol HomeCoordinatorDelegate: AnyObject {
    func openMovieDetails(with movie: MovieViewModel)
}

extension AppCoordinator: HomeCoordinatorDelegate {
    
    func openMovieDetails(with movie: MovieViewModel) {
        
    }
    
}
