//
//  UIScrollView+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 5/18/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

// ******************************* MARK: - Insets

public extension UIScrollView {
    /// Set value for top `contentInset` and `scrollIndicatorInsets`
    public func setTopInset(_ topInset: CGFloat) {
        contentInset.top = topInset
        scrollIndicatorInsets.top = topInset
    }
    
    /// Set 64 for top `contentInset` and `scrollIndicatorInsets`
    public func setTopNavigationBarsInset() {
        setTopInset(64)
    }
    
    /// Set value for top `contentInset` and `scrollIndicatorInsets`
    public func setBottomInset(_ bottomInset: CGFloat) {
        contentInset.bottom = bottomInset
        scrollIndicatorInsets.bottom = bottomInset
    }
    
    /// Set 49 for top `contentInset` and `scrollIndicatorInsets`
    public func setBottomTabBarInset() {
        setBottomInset(49)
    }
    
    /// Assures that contentOffset value is correct.
    public func clampContentOffset() {
        let minOffsetY = -contentInset.top
        let maxOffsetY = max(contentSize.height - bounds.size.height + contentInset.bottom, 0)
        let minOffsetX = -contentInset.left
        let maxOffsetX = max(contentSize.width - bounds.size.width + contentInset.right, 0)
        
        var newContentOffset = contentOffset
        newContentOffset.y = min(newContentOffset.y, maxOffsetY)
        newContentOffset.y = max(newContentOffset.y, minOffsetY)
        newContentOffset.x = min(newContentOffset.x, maxOffsetX)
        newContentOffset.x = max(newContentOffset.x, minOffsetX)
        
        contentOffset = newContentOffset
    }
}

// ******************************* MARK: - UIRefreshControl

private var c_refreshActionAssociationKey = 0

@available(iOS 10.0, *)
public extension UIRefreshControl {
    /// Closure for refresh action.
    /// Takes `UIRefreshControl` that triggered refresh as argument.
    public typealias Action = (UIRefreshControl) -> Void
    
    fileprivate var action: Action? {
        get {
            return objc_getAssociatedObject(self, &c_refreshActionAssociationKey) as? Action
        }
        set {
            objc_setAssociatedObject(self, &c_refreshActionAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc fileprivate func onRefresh(_ sender: UIRefreshControl) {
        action?(self)
    }
}

@available(iOS 10.0, *)
public extension UIScrollView {
    /// Adds refresh control. Call finishRefresh() to stop.
    public func addRefreshControl(action: @escaping UIRefreshControl.Action) {
        let refreshControl = UIRefreshControl()
        refreshControl.action = action
        refreshControl.addTarget(refreshControl, action: #selector(UIRefreshControl.onRefresh(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
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

// ******************************* MARK: - Scroll

public extension UIScrollView {
    public func scrollToBottom(animated: Bool) {
        let height = bounds.size.height
        var y: CGFloat = 0.0
        
        if #available(iOS 11.0, *) {
            y += adjustedContentInset.bottom
        } else {
            y += contentInset.bottom
        }
        
        if contentSize.height > height {
            y += contentSize.height - height
        }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }
}
