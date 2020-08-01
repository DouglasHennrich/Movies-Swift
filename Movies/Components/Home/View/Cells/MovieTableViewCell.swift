//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Douglas Hennrich on 31/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var moviePhoto: UIImageView! {
        didSet {
            moviePhoto.cornerRounded()
        }
    }
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieDescription: UILabel!
    
    @IBOutlet weak var movieReviewer: UILabel!
    
    // MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        moviePhoto.image = nil
        movieReviewer.text = nil
        movieDescription.text = nil
        movieReviewer.text = nil
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: Actions
    func config(with movie: MovieViewModel) {
        moviePhoto.kf.setImage(with: URL(string: movie.photo))
        movieTitle.text = movie.title
        movieDescription.text = movie.description
        movieReviewer.text = movie.reviewer
    }
    
}
