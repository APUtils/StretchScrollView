//
//  CollectionView.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 7/14/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


/// Collection view that resizes it's cells to be the same size as collection view.
open class FullSizeCollectionView: CollectionView {
    
    //-----------------------------------------------------------------------------
    // MARK: - UIView Properties
    //-----------------------------------------------------------------------------
    
    override open var bounds: CGRect { willSet { configure(newSize: newValue.size) } }
    
    //-----------------------------------------------------------------------------
    // MARK: - Private Properties
    //-----------------------------------------------------------------------------
    
    private var previousSize: CGSize = .zero
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization, Setup and Configuration
    //-----------------------------------------------------------------------------
    
    private func setup() {
        configure(newSize: bounds.size)
    }
    
    private func configure(newSize: CGSize) {
        guard previousSize != newSize, let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        previousSize = newSize
        
        flowLayout.itemSize = newSize
        collectionViewLayout.invalidateLayout()
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - UIView Methods
    //-----------------------------------------------------------------------------
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
}
