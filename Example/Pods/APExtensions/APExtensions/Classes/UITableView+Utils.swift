//
//  UITableView+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 12/23/16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit

//-----------------------------------------------------------------------------
// MARK: - Cells, Header and Footer reuse
//-----------------------------------------------------------------------------

public extension UITableView {
    
    //-----------------------------------------------------------------------------
    // MARK: - Cell
    //-----------------------------------------------------------------------------
    
    public func registerNib(cellClass: ClassName.Type) {
        register(UINib(nibName: cellClass.className, bundle: nil), forCellReuseIdentifier: cellClass.className)
    }
    
    public func dequeue<T: ClassName>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: T.className, for: indexPath) as! T
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Header and Footer
    //-----------------------------------------------------------------------------
    
    public func registerNib(headerFooterClass: ClassName.Type) {
        register(UINib(nibName: headerFooterClass.className, bundle: nil), forHeaderFooterViewReuseIdentifier: headerFooterClass.className)
    }
    
    public func dequeueReusableHeaderFooter<T: ClassName>() -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.className) as! T
    }
}

//-----------------------------------------------------------------------------
// MARK: - Reload
//-----------------------------------------------------------------------------

public extension UITableView {
    public func reloadDataKeepingContentOffset() {
        let bottomOffset = contentSize.height - (contentOffset.y + bounds.height)
        reloadData()
        layoutIfNeeded()
        contentOffset.y = contentSize.height - (bottomOffset + bounds.height)
    }
}

//-----------------------------------------------------------------------------
// MARK: - UIRefreshControl
//-----------------------------------------------------------------------------

public extension UITableView {
    public func addRefreshControl(target: AnyObject?, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshControl
        } else {
            backgroundView = refreshControl
        }
    }
    
    public func finishRefresh() {
        if #available(iOS 10.0, *) {
            refreshControl?.endRefreshing()
        } else {
            (backgroundView as? UIRefreshControl)?.endRefreshing()
        }
    }
}
