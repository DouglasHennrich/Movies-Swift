//
//  Fonts.swift
//  Movies
//
//  Created by Douglas Hennrich on 28/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum Lato: String {
        case italic = "Lato-Italic"
        case light = "Lato-Light"
        case regular = "Lato-Regular"
        case semibold = "Lato-Semibold"
        case bold = "Lato-Bold"
        
        func fontWith(size: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: size)!
        }
    }
    
}
