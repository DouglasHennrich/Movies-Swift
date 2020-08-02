//
//  DetailsViewController.swift
//  Movies
//
//  Created by Douglas Hennrich on 02/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit
import ParallaxHeader
import SafariServices

class DetailsViewController: UIViewController, Storyboarded {

    // MARK: Properties
    var viewModel: DetailsViewModelDelegate?
    var updateCellOnBack: (() -> Void)?
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            
            // Generic Cell
            tableView.register(GenericTableViewCell.loadNib(),
                               forCellReuseIdentifier: GenericTableViewCell.identifier)
            
            // Date & Rating
            tableView.register(DateAndRatingTableViewCell.loadNib(),
                               forCellReuseIdentifier: DateAndRatingTableViewCell.identifier)
            
            // Link
            tableView.register(LinkTableViewCell.loadNib(),
                               forCellReuseIdentifier: LinkTableViewCell.identifier)
        }
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel?.navTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .background
        
        addFavoriteButton()
        addMovieImage(with: viewModel?.getPhoto() ?? "")
        setUpBinds()
        
        view.startLoader()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateCellOnBack?()
    }
    
    // MARK: Actions
    private func addFavoriteButton() {
        let favoriteButton = UIBarButtonItem(image: UIImage.Icons.heart,
                                             style: .plain, target: self,
                                             action: #selector(onFavoriteButton))
        
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    @objc func onFavoriteButton() {
        viewModel?.onFavoritePressed()
    }
    
    private func addMovieImage(with image: String) {
        let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFit
        imageView.kf.setImage(with: URL(string: image)) { [weak self] result in
            if case .failure = result {
                imageView.image = nil
            } else {
                self?.tableView.parallaxHeader.view = imageView
                self?.tableView.parallaxHeader.height = 300
                self?.tableView.parallaxHeader.minimumHeight = 0
                self?.tableView.parallaxHeader.mode = .topFill
            }
        }
    }
    
    private func setUpBinds() {
        
        viewModel?.favorited.bindAndFire { [weak self] value in
            if value {
                self?.navigationItem.rightBarButtonItem?.tintColor = .hightlight

            } else {
                self?.navigationItem.rightBarButtonItem?.tintColor = .primary
            }
        }
        
    }
    
    private func handleDequeueingCells(at indexPath: IndexPath) -> UITableViewCell {
        guard let parameters = viewModel?.getIem(on: indexPath.section, at: indexPath.row)
            else {
                return UITableViewCell()
        }
        
        switch parameters.type {
        case .typeAndDescription, .reviewerAndHeadline:
            return dequeueGeneric(with: parameters.data, at: indexPath)
        case .dateAndRating:
            return dequeueDateAndRating(with: parameters.data, at: indexPath)
        case .link:
            return dequeueLink(with: parameters.data, at: indexPath)
        }
    }
    
    private func dequeueGeneric(with data: [String: Any], at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GenericTableViewCell.identifier,
            for: indexPath) as? GenericTableViewCell,
            let firstLabelKey = data["firstLabelKey"] as? String,
            let secondLabelKey = data["secondLabelKey"] as? String,
            let secondLabelValue = data["secondLabelValue"] as? String
            else {
                return UITableViewCell()
        }
        
        let firstLabelValue = data["firstLabelValue"]
        
        cell.config(withFirstLabelKey: firstLabelKey,
                    withFirstLabelValue: firstLabelValue,
                    withSecondLabelKey: secondLabelKey,
                    withSecondLabelValue: secondLabelValue)
        
        return cell
    }
    
    private func dequeueDateAndRating(with data: [String: Any], at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DateAndRatingTableViewCell.identifier,
            for: indexPath) as? DateAndRatingTableViewCell,
            let openingDate = data["openingDate"] as? String,
            let publicDate = data["publicDate"] as? String,
            let updatedDate = data["updatedDate"] as? String
            else {
                return UITableViewCell()
        }
        
        cell.config(withOpeningDate: openingDate,
                    withPublicDate: publicDate,
                    withUpdatedDate: updatedDate,
                    withRate: data["rate"] as? String)
        
        return cell
    }
    
    private func dequeueLink(with data: [String: Any], at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LinkTableViewCell.identifier,
            for: indexPath) as? LinkTableViewCell,
            let link = data["link"] as? String,
            let description = data["description"] as? String
            else {
                return UITableViewCell()
        }
        
        cell.config(withDescription: description) { [weak self] in
            if let url = URL(string: link) {
                let vc = SFSafariViewController(url: url)
                self?.present(vc, animated: true)
            }
        }
        
        return cell
    }

}

// MARK: UITableView DataSource
extension DetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return handleDequeueingCells(at: indexPath)
    }
    
}

// MARK: UITableView Delegate
extension DetailsViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.getSectionsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            Timer.scheduledTimer(withTimeInterval: 1,
                                 repeats: false) { [weak self] timer in
                                    timer.invalidate()
                                    self?.view.stopLoader()
            }
        }
    }
    
}
