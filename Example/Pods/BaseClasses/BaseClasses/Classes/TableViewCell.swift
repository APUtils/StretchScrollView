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

/// TableViewCell with disabled views background color change
open class TableViewCell: UITableViewCell {
    
    //-----------------------------------------------------------------------------
    // MARK: - UITableViewCell Methods
    //-----------------------------------------------------------------------------
    
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
    
    private func getViewsBackgrounds() -> [UIView: UIColor?] {
        var viewsBackgrounds: [UIView: UIColor?] = [:]
        contentView.allSubviews.forEach({ viewsBackgrounds[$0] = $0.backgroundColor })
        
        return viewsBackgrounds
    }
}
