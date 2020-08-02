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
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchTask: DispatchWorkItem?
    let searchInterval: Double = 0.5
    
    var firstTime: Bool = true
    var searchingMovie: Bool = false
    var viewModel: HomeViewModelDelegate?
    
    var isLoading: Bool = false
    var noMoreData: Bool = false
    
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
            
            // Loading
            tableView.register(LoadingTableViewCell.loadNib(),
                               forCellReuseIdentifier: LoadingTableViewCell.identifier)
            
            // Refresh control
            tableView.refreshControl = refreshControl
            tableView.keyboardDismissMode = .onDrag
        }
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configRefreshControl()
        setupSearchBar()
        
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
            self?.isLoading = false
        }
        
        viewModel?.search.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        viewModel?.noMoreData.bind { [weak self] value in
            if value {
                self?.noMoreData = true
                self?.tableView.deleteSections(IndexSet(integer: 2),
                                               with: .none)
            } else {
                self?.noMoreData = false
            }
        }
        
    }

    @objc private func onRefresh() {
        searchingMovie = false
        view.endEditing(true)
        searchController.searchBar.text = ""
        noMoreData = false
        viewModel?.getMovies(fromRefresh: true)
    }
    
}
