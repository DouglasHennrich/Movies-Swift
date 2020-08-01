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
    private lazy var logger: Logger = Logger.forClass(Self.self)
    private var refreshControl = UIRefreshControl()
    var viewModel: HomeViewModelDelegate?
    var firstTime: Bool = true
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
//            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
            
            // Header
            tableView.register(CustomTitleTableViewHeader.loadNib(),
                               forHeaderFooterViewReuseIdentifier: CustomTitleTableViewHeader.identifier)
            
            // Highlight
            tableView.register(HighlightTableViewCell.loadNib(),
                               forCellReuseIdentifier: HighlightTableViewCell.identifier)
            
            // Movies
            tableView.register(MovieTableViewCell.loadNib(),
                               forCellReuseIdentifier: MovieTableViewCell.identifier)
            
            // Refresh control
            tableView.refreshControl = refreshControl
        }
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configRefreshControl()
        
        setUpBinds()
        viewModel?.getMovies(fromRefresh: false)
    }
    
    // MARK: Actions
    private func configRefreshControl() {
        refreshControl.tintColor = .primary
        let text = "Recarregar filmes"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font,
                                      value: UIFont.Lato.regular.fontWith(size: 16),
                                      range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.hightlight,
                                      range: NSRange(location: 0,
                                                     length: text.count))
        
        refreshControl.attributedTitle = attributedString
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }
    
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
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
        
    }

    @objc private func onRefresh() {
        viewModel?.getMovies(fromRefresh: true)
    }
}

// MARK: TableView Delegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 280
        }
        
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: CustomTitleTableViewHeader.identifier) as? CustomTitleTableViewHeader
            else {
                return nil
        }
        header.config(with: section == 0 ? .highlights : .movies)
        
        return header
    }
    
}

// MARK: TableView Data Source
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
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
            return section == 0 ? 1 : count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel != nil else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HighlightTableViewCell.identifier,
                                                           for: indexPath) as? HighlightTableViewCell
                else {
                    return UITableViewCell()
            }
            
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier,
                                                       for: indexPath) as? MovieTableViewCell,
            let movie = viewModel?.getMovie(on: indexPath.section, at: indexPath.row)
            else {
                return UITableViewCell()
        }
        
        cell.config(with: movie)
        return cell
    }
    
}

// MARK: CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.openMovie(on: indexPath.section, at: indexPath.row)
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
