//
//  UIColor+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 09/04/16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension UIColor {
    /// Init color from 0-255 RGB components
    public convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    /// Init color from hex value
    public convenience init(hex: Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    /// Return lighter color. 1.0 - white, 0.0 - same as receiver.
    public func lighterColor(amount: CGFloat) -> UIColor {
        let amount = min(max(amount, 0), 1)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let newRed = red + (1 - red) * amount
            let newGreen = green + (1 - green) * amount
            let newBlue = blue + (1 - blue) * amount
            let newAlpha = alpha + (1 - alpha) * amount
            
            return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
        } else {
            return self
        }
    }
}
