//
//  UINavigationBar+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 7/14/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension UINavigationBar {
    /// Set navigation bar transparency
    public func setTransparent(_ isTransparent: Bool) {
        if isTransparent {
            isTranslucent = true
            setBackgroundImage(UIImage(), for: .default)
            shadowImage = UIImage()
        } else {
            setBackgroundImage(nil, for: .default)
            shadowImage = nil
        }
    }
}
