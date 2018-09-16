//
//  Extensions.swift
//  cARd
//
//  Created by Ryan Sullivan on 9/15/18.
//  Copyright © 2018 card. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public static var linkedinBlue: UIColor {
        get {
            return UIColor(red: 48/255.0, green: 118/255.0, blue: 176/255.0, alpha: 1.0)
        }
    }
    
    public static func random() -> UIColor {
        let r = CGFloat(arc4random() % 255) / 255
        let g = CGFloat(arc4random() % 255) / 255
        let b = CGFloat(arc4random() % 255) / 255
        print(r,g,b)
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
