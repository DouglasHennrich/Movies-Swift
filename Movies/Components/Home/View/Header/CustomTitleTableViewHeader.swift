//
//  HighlightTableViewHeader.swift
//  Movies
//
//  Created by Douglas Hennrich on 31/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

class CustomTitleTableViewHeader: UITableViewHeaderFooterView {
    
    //
    enum TitleType: String {
        case highlights = "Destaques"
        case movies = "Filmes"
    }
    
    // MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let headerBackground = UIView(frame: self.frame)
        self.backgroundView = headerBackground
        self.backgroundView?.backgroundColor = UIColor.CustomHeader.background
    }
    
    // MARK: Actions
    func config(with type: TitleType) {
        titleLabel.text = type.rawValue
        
        if type == .movies {
            titleLabel.font = UIFont.Lato.bold.fontWith(size: 30)
        }
    }
    
}
