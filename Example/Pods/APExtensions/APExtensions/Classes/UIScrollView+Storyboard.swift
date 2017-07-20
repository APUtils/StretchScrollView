//
//  UIScrollView+Storyboard.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 5/18/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension UIScrollView {
    /// Sets top 64 for inset
    @IBInspectable var avoidTopBars: Bool {
        get {
            return contentInset.top == 64
        }
        set {
            setTopNavigationBarsInset()
        }
    }
    
    /// Sets 49 for bottom inset
    @IBInspectable var avoidTabBar: Bool {
        get {
            return contentInset.top == 49
        }
        set {
            setBottomTabBarInset()
        }
    }
}
