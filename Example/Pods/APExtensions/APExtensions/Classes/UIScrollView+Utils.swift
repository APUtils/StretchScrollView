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
    
    /// Assures that contentOffset value is correct.
    public func clampContentOffset() {
        var newContentOffset = contentOffset
        newContentOffset.y = min(newContentOffset.y, contentSize.height - height)
        newContentOffset.y = min(newContentOffset.y, -contentInset.top)
    }
}

//-----------------------------------------------------------------------------
// MARK: - UIRefreshControl
//-----------------------------------------------------------------------------

@available(iOS 10.0, *)
public extension UIScrollView {
    /// Adds refresh control. Call finishRefresh() to stop.
    public func addRefreshControl(target: AnyObject?, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    /// Stops refresh
    public func finishRefresh() {
        refreshControl?.endRefreshing()
    }
}
