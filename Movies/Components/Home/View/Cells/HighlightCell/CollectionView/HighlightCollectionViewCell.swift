//
//  HightlighCollectionViewCell.swift
//  Movies
//
//  Created by Douglas Hennrich on 31/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit
import Kingfisher

class HighlightCollectionViewCell: UICollectionViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var moviePhoto: UIImageView!
    
    @IBOutlet weak var movieLabel: UILabel!
    
    // MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        moviePhoto.image = nil
        movieLabel.text = nil
        super.prepareForReuse()
    }
    
    // MARK: Actions
    func config(with movie: MovieViewModel) {
        moviePhoto.kf.setImage(with: URL(string: movie.photo))
        movieLabel.text = movie.title
    }

}
