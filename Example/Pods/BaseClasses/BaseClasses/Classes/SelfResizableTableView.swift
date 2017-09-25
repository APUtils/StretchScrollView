//
//  SelfResizableTableView.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 9/14/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

open class SelfResizableTableView: TableView {
    
    //-----------------------------------------------------------------------------
    // MARK: - UIView Overrides
    //-----------------------------------------------------------------------------
    
    open override var contentSize: CGSize {
        didSet {
            guard oldValue != contentSize else { return }
            
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = contentSize
        intrinsicContentSize.height += contentInset.top
        intrinsicContentSize.height += contentInset.bottom
        intrinsicContentSize.width += contentInset.left
        intrinsicContentSize.width += contentInset.right
        
        return intrinsicContentSize
    }
}
