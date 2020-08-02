//
//  HomeViewControllerExtensionCollectionView.swift
//  Movies
//
//  Created by Douglas Hennrich on 01/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

// MARK: CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.endEditing(true)
        searchingMovie = false
        
        viewModel?.openMovie(on: indexPath.section, at: indexPath.row) { [weak self] in
            self?.onRefresh()
        }
    }
    
}

// MARK: CollectionView DataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.highlightsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel,
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HighlightCollectionViewCell.identifier,
                for: indexPath) as? HighlightCollectionViewCell,
            let movie = viewModel.getMovie(on: indexPath.section, at: indexPath.row)
            else {
                return UICollectionViewCell()
        }
        
        cell.config(with: movie)
        return cell
    }
    
}
