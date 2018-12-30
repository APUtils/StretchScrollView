//
//  TableViewCell.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 6/15/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

//-----------------------------------------------------------------------------
// MARK: - Helper Extension
//-----------------------------------------------------------------------------

private extension UIView {
    var allSubviews: [UIView] {
        var allSubviews = self.subviews
        
        allSubviews.forEach { allSubviews.append(contentsOf: $0.allSubviews) }
        
        return allSubviews
    }
}

//-----------------------------------------------------------------------------
// MARK: - Class Implementation
//-----------------------------------------------------------------------------

/// TableViewCell with disabled views background color change and `reuseId` property.
open class TableViewCell: UITableViewCell {
    
    //-----------------------------------------------------------------------------
    // MARK: - Public Properties
    //-----------------------------------------------------------------------------
    
    /// Increases every time cell was reused. May be used to determine if async update should be performed in this cell.
    final private(set) public var reuseId: UInt = 0
    
    //-----------------------------------------------------------------------------
    // MARK: - UITableViewCell Overrides
    //-----------------------------------------------------------------------------
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        changeReuseId()
    }
    
    // Preventing backgroundColor change
    override open func setSelected(_ selected: Bool, animated: Bool) {
        let viewsBackgrounds: [UIView: UIColor?] = getViewsBackgrounds()
        
        super.setSelected(selected, animated: animated)
        
        if selected {
            for (view, color) in viewsBackgrounds {
                view.backgroundColor = color
            }
        }
    }
    
    // Preventing backgroundColor change
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let viewsBackgrounds: [UIView: UIColor?] = getViewsBackgrounds()
        
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            for (view, color) in viewsBackgrounds {
                view.backgroundColor = color
            }
        }
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Private Methods
    //-----------------------------------------------------------------------------
    
    private func changeReuseId() {
        reuseId = reuseId &+ 1
    }
    
    private func getViewsBackgrounds() -> [UIView: UIColor?] {
        var viewsBackgrounds: [UIView: UIColor?] = [:]
        contentView.allSubviews.forEach({ viewsBackgrounds[$0] = $0.backgroundColor })
        
        return viewsBackgrounds
    }
}
