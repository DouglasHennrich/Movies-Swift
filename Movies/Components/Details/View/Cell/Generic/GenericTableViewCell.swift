//
//  GenericTableViewCell.swift
//  Movies
//
//  Created by Douglas Hennrich on 02/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

class GenericTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var firstLabelKey: UILabel!
    @IBOutlet weak var firstLabelValue: UILabel!
    @IBOutlet weak var secondLabelKey: UILabel!
    @IBOutlet weak var secondLabelValue: UILabel!
    
    // MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    // MARK: Actions
    func config(withFirstLabelKey firstLabelKey: String,
                withFirstLabelValue firstLabelValue: Any?,
                withSecondLabelKey secondLabelKey: String,
                withSecondLabelValue secondLabelValue: String) {
        self.firstLabelKey.text = firstLabelKey
        
        if let attributed = firstLabelValue as? NSMutableAttributedString {
            self.firstLabelValue.attributedText = attributed
            
        } else {
            self.firstLabelValue.text = firstLabelValue as? String
        }
        
        self.secondLabelKey.text = secondLabelKey
        self.secondLabelValue.text = secondLabelValue
    }
    
}
