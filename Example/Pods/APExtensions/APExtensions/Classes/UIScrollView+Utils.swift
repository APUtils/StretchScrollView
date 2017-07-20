//
//  UIScrollView+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 5/18/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

//-----------------------------------------------------------------------------
// MARK: - Insets
//-----------------------------------------------------------------------------

public extension UIScrollView {
    public func setTopInset(_ topInset: CGFloat) {
        contentInset.top = topInset
    }
    
    public func setTopNavigationBarsInset() {
        setTopInset(64)
    }
    
    public func setBottomInset(_ bottomInset: CGFloat) {
        contentInset.bottom = bottomInset
    }
    
    public func setBottomTabBarInset() {
        setBottomInset(49)
    }
    
    public func clampContentOffset() {
        var newContentOffset = contentOffset
        newContentOffset.y = min(newContentOffset.y, contentSize.height - height)
        newContentOffset.y = min(newContentOffset.y, -contentInset.top)
    }
}
