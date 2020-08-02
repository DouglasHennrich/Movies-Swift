//
//  HomeViewControllerExtensionSearchBar.swift
//  Movies
//
//  Created by Douglas Hennrich on 01/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

extension HomeViewController: UISearchBarDelegate {
    
    func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar por filme"
        searchController.searchBar.searchBarStyle = .minimal
        
        let glassIconView = searchController.searchBar.searchTextField.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = .hightlight
        
        searchController.searchBar.searchTextField.textColor = .primary
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let textToSearch = searchBar.text,
            !textToSearch.isEmpty else {
                searchingMovie = false
                viewModel?.resetSearch()
                return
        }
        
        if textToSearch.count > 2 {
            searchTask?.cancel()

            // Replace previous task with a new one
            let task = DispatchWorkItem { [weak self] in
                self?.searchingMovie = true
                self?.fetchResults(for: textToSearch)
            }
            self.searchTask = task

            // Execute task if not cancelled
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + searchInterval, execute: task)
        }
    }
    
    func fetchResults(for text: String) {
        print("Text Searched: \(text)")
        viewModel?.searchMovies(for: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchingMovie = false
        viewModel?.resetSearch()
    }
    
}
