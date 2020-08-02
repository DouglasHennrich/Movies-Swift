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
    
    @IBOutlet weak var favoriteIcon: UIImageView! {
        didSet {
            favoriteIcon.isHidden = true
            favoriteIcon.image = UIImage.Icons.heart
            favoriteIcon.tintColor = .hightlight
        }
    }
    
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
        favoriteIcon.isHidden = true
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
        
        favoriteIcon.isHidden = !movie.favorited
    }
    
}
