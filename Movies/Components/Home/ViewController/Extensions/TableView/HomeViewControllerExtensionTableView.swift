//
//  HomeViewControllerExtensionTableView.swift
//  Movies
//
//  Created by Douglas Hennrich on 01/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

// MARK: Actions
extension HomeViewController {
    
    func dequeueCells(indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
            let movie = viewModel.getMovie(on: indexPath.section, at: indexPath.row)
            else {
                return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            if searchingMovie {
                return dequeueMovieCell(with: movie, at: indexPath)
            } else {
                return dequeueHighlights(at: indexPath)
            }
            
        case 1:
            return dequeueMovieCell(with: movie, at: indexPath)
            
        case 2:
            return dequeueLoadingCell(at: indexPath)
            
        default:
            return UITableViewCell()
        }
    }
    
    // Dequeue Movie
    func dequeueMovieCell(with movie: MovieViewModel, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier,
                                                       for: indexPath) as? MovieTableViewCell
            else {
                return UITableViewCell()
        }
        
        cell.config(with: movie)
        return cell
    }
    
    // Dequeue Highlight
    func dequeueHighlights(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HighlightTableViewCell.identifier,
                                                       for: indexPath) as? HighlightTableViewCell
            else {
                return UITableViewCell()
        }
        
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        return cell
    }
    
    // Dequeue Loading
    func dequeueLoadingCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LoadingTableViewCell.identifier,
            for: indexPath) as? LoadingTableViewCell
            else {
                return UITableViewCell()
        }
        
        cell.activityIndicator.startAnimating()
        return cell
    }
    
}

// MARK: TableView Delegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // HighlightCell
        if indexPath.section == 0 && !searchingMovie {
            return 280
        }
        
        // Loading cell
        if indexPath.section == 2 {
            return 44
        }
        
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? .zero : 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searchingMovie || section == 2 {
            let header = UIView()
            header.backgroundColor = UIColor.CustomHeader.background
            return header
        }
        
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: CustomTitleTableViewHeader.identifier) as? CustomTitleTableViewHeader
            else {
                return nil
        }
        header.config(with: section == 0 ? .highlights : .movies)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.endEditing(true)
        viewModel?.openMovie(on: indexPath.section, at: indexPath.row) { [weak self] in
            self?.onRefresh()
        }
    }
    
}

// MARK: TableView Data Source
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchingMovie ? 1 :
            noMoreData ? 2 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else {
            tableView.setEmptyMessage("Nenhum filme encontrado no momento", firstTime)
            return 0
        }
        
        if searchingMovie {
            return viewModel.search.value.count
        }
        
        let count = viewModel.movies.value.count
        
        if count == 0 {
            tableView.setEmptyMessage("Nenhum filme encontrado", firstTime)
            return 0
            
        } else {
            tableView.restore()
            
            switch section {
            case 1:
                return count
            case 0, 2:
                return 1
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dequeueCells(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
        UISwipeActionsConfiguration? {
            
        guard let viewModel = viewModel,
            (!searchingMovie && indexPath.section != 0),
            let movie = viewModel.getMovie(on: indexPath.section, at: indexPath.row)
            else {
                return nil
                
            }
        
            let title = movie.favorited ? "Desfavoritar" : "Favoritar"
        
            let action = UIContextualAction(style: .normal,
                                            title: title,
                                            handler: { _, _, completionHandler in
                                                movie.favorited ?
                                                    FavoritesManager.shared.remove(movie) :
                                                    FavoritesManager.shared.save(movie)
                                                
                                                (tableView.cellForRow(at: indexPath) as? MovieTableViewCell)?
                                                    .config(with: movie)
                                                
                                                completionHandler(true)
            })

            action.image = UIImage.Icons.heart
            action.image?.withTintColor(.hightlight)
            
            action.backgroundColor = .hightlight
            let configuration = UISwipeActionsConfiguration(actions: [action])
            return configuration
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if (offsetY > contentHeight - scrollView.frame.height * 2) &&
            !isLoading && !noMoreData {
            isLoading = true
            viewModel?.loadMore()
        }
    }
    
}
