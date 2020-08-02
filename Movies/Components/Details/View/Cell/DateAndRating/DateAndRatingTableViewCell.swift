//
//  DateAndRatingTableViewCell.swift
//  Movies
//
//  Created by Douglas Hennrich on 02/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

class DateAndRatingTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var openingDateLabel: UILabel!
    @IBOutlet weak var publicDateLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    
    @IBOutlet weak var rateContainer: UIView! {
        didSet {
            rateContainer.cornerRounded(with: 5)
        }
    }
    @IBOutlet weak var rateLabel: UILabel!
    
    // MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        rateContainer.isHidden = true
        super.prepareForReuse()
    }
    
    // MARK: Config
    func config(withOpeningDate openingDate: String,
                withPublicDate publicDate: String,
                withUpdatedDate updatedDate: String,
                withRate rate: String?) {
        
        openingDateLabel.text = openingDate
        publicDateLabel.text = publicDate
        updateDateLabel.text = updatedDate
        
        guard let rate = rate,
            !rate.isEmpty
            else {
                rateContainer.isHidden = true
                return
        }
        
        rateContainer.isHidden = false
        rateLabel.text = rate
    }
    
}
