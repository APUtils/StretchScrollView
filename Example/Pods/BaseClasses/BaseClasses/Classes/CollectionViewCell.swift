//
//  CollectionViewCell.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 11/10/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


/// CollectionViewCell with `reuseId` property.
open class CollectionViewCell: UICollectionViewCell {
    
    //-----------------------------------------------------------------------------
    // MARK: - Public Properties
    //-----------------------------------------------------------------------------
    
    /// Increases every time cell was reused. May be used to determine if async update should be performed in this cell.
    private(set) public var reuseId: UInt = 0
    
    //-----------------------------------------------------------------------------
    // MARK: - CollectionViewCell Overrides
    //-----------------------------------------------------------------------------
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        changeReuseId()
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Private Methods
    //-----------------------------------------------------------------------------
    
    private func changeReuseId() {
        reuseId = reuseId &+ 1
    }
}
