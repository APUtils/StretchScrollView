//
//  UIFont+Storyboard.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 6/20/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


private let roundFontSize = false


public extension UIFont {
    /// Returns screen scaled font. Assuming source font is for 2208x1242 screen.
    public var screenFitFont: UIFont {
        let baseScreenSize: CGFloat = 414 // iPhone 6+
        let currentScreenSize = UIScreen.main.bounds.width
        let fontResizeCoef = currentScreenSize / baseScreenSize
        var newFontSize = pointSize * fontResizeCoef
        if roundFontSize {
            newFontSize = newFontSize.rounded(.toNearestOrEven)
        }
        
        return UIFont(descriptor: fontDescriptor, size: newFontSize)
    }
    
    
    // TODO: Add Dynamic Type with UIFontMetrics for iOS 11
}
