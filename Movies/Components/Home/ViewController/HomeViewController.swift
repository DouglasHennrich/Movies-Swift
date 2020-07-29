//
//  HomeViewController.swift
//  Movies
//
//  Created by Douglas Hennrich on 28/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Storyboarded {

    // MARK: Properties
    var viewModel: HomeViewModelDelegate?
    var firstTime: Bool = true
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(HightlightTableViewCell.loadNib(),
                               forCellReuseIdentifier: HightlightTableViewCell.identifier)
            
            tableView.backgroundView?.alpha = 0
        }
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBinds()
        viewModel?.getMovies()
    }
    
    // MARK: Actions
    private func setUpBinds() {
        
        viewModel?.loading.bind { [weak self] params in
            params.actived ? self?.view.startLoader(message: params.message) : self?.view.stopLoader()
        }
        
        viewModel?.error.bind { [weak self] message in
            guard let self = self else { return }
            UIAlertController.showAlert(vc: self, message: message)
        }
        
        viewModel?.movies.bind { [weak self] _ in
            self?.firstTime = false
            self?.tableView.reloadData()
        }
        
    }

}

// MARK: TableView Delegate
extension HomeViewController: UITableViewDelegate {
    
}

// MARK: TableView Data Source
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else {
            tableView.setEmptyMessage("Nenhum filme encontrado no momento", firstTime)
            return 0
        }
        
        let count = viewModel.movies.value.count
        
        if count == 0 {
            tableView.setEmptyMessage("Nenhum filme encontrado no momento", firstTime)
            return 0
        } else {
            tableView.restore()
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
