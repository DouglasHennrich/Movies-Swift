//
//  HightlightTableViewCell.swift
//  Movies
//
//  Created by Douglas Hennrich on 28/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

class HighlightTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    // MARK: IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(HighlightCollectionViewCell.loadNib(),
                                    forCellWithReuseIdentifier: HighlightCollectionViewCell.identifier)
        }
    }
    
    // MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        collectionView.delegate = nil
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Actions
    func setCollectionViewDataSourceDelegate(_ dataSourceDelegate: UICollectionViewDataSource &
                                             UICollectionViewDelegate,
                                             forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.reloadData()
    }
    
}
