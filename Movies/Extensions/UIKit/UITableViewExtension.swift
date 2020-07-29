//
//  UITableViewExtension.swift
//  Movies
//
//  Created by Douglas Hennrich on 29/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

extension UITableView {

    func setEmptyMessage(_ message: String, _ beHidden: Bool = false) {
        let messageLabel = UILabel(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: self.bounds.size.width,
                                                 height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .primary
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.Lato.semibold.fontWith(size: 18)
        messageLabel.sizeToFit()
        messageLabel.isHidden = beHidden

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
}
