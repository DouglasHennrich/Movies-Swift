//
//  AppCoordinator.swift
//  Movies
//
//  Created by Douglas Hennrich on 28/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: Properties
    var navigationController: UINavigationController
    
    // MARK: Init
    init() {
        navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .hightlight
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.primary
        ]
        navigationController.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.primary
        ]
    }
    
    // MARK: Actions
    func start() {
        let viewModel = HomeViewModel(navigation: self)
        let vc = HomeViewController.instantiateFromStoryboard(named: "Home")
        vc.viewModel = viewModel
        
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: false)
    }
    
}
