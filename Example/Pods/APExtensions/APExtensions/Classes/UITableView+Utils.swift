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
    
    /// Simplifies cell registration. Xib name must be the same as class name.
    public func registerNib(cellClass: ClassName.Type) {
        register(UINib(nibName: cellClass.className, bundle: nil), forCellReuseIdentifier: cellClass.className)
    }
    
    /// Simplifies cell dequeue. Specify type of variable on declaration so proper cell will be dequeued.
    ///
    /// Example:
    ///
    ///     let cell: MyCell = tableView.dequeue(indexPath)
    public func dequeue<T: ClassName>(_ indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: T.className, for: indexPath) as! T
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Header and Footer
    //-----------------------------------------------------------------------------
    
    /// Simplifies header/footer registration. Xib name must be the same as class name.
    public func registerNib(headerFooterClass: ClassName.Type) {
        register(UINib(nibName: headerFooterClass.className, bundle: nil), forHeaderFooterViewReuseIdentifier: headerFooterClass.className)
    }
    
    /// Simplifies header/footer dequeue. Specify type of variable on declaration so proper cell will be dequeued.
    /// Example:
    ///
    ///     let view: MyHeaderFooter = tableView.dequeueReusableHeaderFooter()
    public func dequeueReusableHeaderFooter<T: ClassName>() -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.className) as! T
    }
}

//-----------------------------------------------------------------------------
// MARK: - Reload
//-----------------------------------------------------------------------------

public extension UITableView {
    /// Assures content offeset won't change after reload
    public func reloadDataKeepingContentOffset() {
        let bottomOffset = contentSize.height - (contentOffset.y + bounds.height)
        reloadData()
        layoutIfNeeded()
        contentOffset.y = contentSize.height - (bottomOffset + bounds.height)
    }
}
