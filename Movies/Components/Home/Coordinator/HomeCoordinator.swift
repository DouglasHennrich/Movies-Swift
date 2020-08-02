//
//  HomeCoordinator.swift
//  Movies
//
//  Created by Douglas Hennrich on 28/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import Foundation

protocol HomeCoordinatorDelegate: AnyObject {
    func openMovieDetails(with movie: MovieViewModel, onBackFromDetails: @escaping () -> Void)
}

extension AppCoordinator: HomeCoordinatorDelegate {
    
    func openMovieDetails(with movie: MovieViewModel, onBackFromDetails: @escaping () -> Void) {
        let viewModel = DetailsViewModel(movie: movie)
        let vc = DetailsViewController.instantiateFromStoryboard(named: "Details")
        vc.viewModel = viewModel
        vc.updateCellOnBack = onBackFromDetails
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(vc, animated: true)
    }
    
}
