//
//  LinkTableViewCell.swift
//  Movies
//
//  Created by Douglas Hennrich on 02/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {

    // MARK: Properties
    var onOpenLink: (() -> Void)?
    
    // MARK: IBOutlets
    @IBOutlet weak var articleLabel: UILabel!
    
    // MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        onOpenLink = nil
        super.prepareForReuse()
    }
    
    // MARK: Config
    func config(withDescription description: String,
                withAction action: @escaping () -> Void) {
        
        articleLabel.text = description
        onOpenLink = action
    }
    
    @IBAction func onButtonPressed(_ sender: UIButton) {
        onOpenLink?()
    }
    
}
