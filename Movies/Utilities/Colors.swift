//
//  Colors.swift
//  Eventos
//
//  Created by Douglas Hennrich on 22/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let background: UIColor = UIColor(red: 43/255.0, green: 45/255.0, blue: 66/255.0, alpha: 1.0)
    static let primary: UIColor = UIColor(red: 237/255.0, green: 242/255.0, blue: 244/255.0, alpha: 1.0)
    static let secondary: UIColor = UIColor(red: 141/255.0, green: 153/255.0, blue: 62/255.0, alpha: 1.0)
    static let hightlight: UIColor = UIColor(red: 4/255.0, green: 102/255.0, blue: 60/255.0, alpha: 1.0)
    static let hightlightOver: UIColor = UIColor(red: 2/255.0, green: 62/255.0, blue: 125/255.0, alpha: 1.0)

    // Used in Letter Image Generate
    struct ImageLetter {
        static let letterImageGeneratorBackground: UIColor = UIColor(
            red: 43/255.0,
            green: 45/255.0,
            blue: 66/255.0,
            alpha: 1.0)
        
        static var letterImageGeneratorLabel: UIColor = UIColor(
            red: 237/255.0,
            green: 242/255.0,
            blue: 244/255.0,
            alpha: 1.0)
        
        static let letterImageGeneratorBorder: UIColor = UIColor(
            red: 141/255.0,
            green: 153/255.0,
            blue: 62/255.0,
            alpha: 1.0)
    }
    
}
