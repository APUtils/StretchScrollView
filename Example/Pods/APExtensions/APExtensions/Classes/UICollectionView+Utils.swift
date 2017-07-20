//
//  UICollectionView+Utils.swift
//  APExtensions
//
//  Created by jean baptiste Bichon on 01/02/2017.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension UICollectionView {
    
    //-----------------------------------------------------------------------------
    // MARK: - Cell Nib
    //-----------------------------------------------------------------------------
    
    public func registerNib(cellClass: ClassName.Type) {
        register(UINib(nibName: cellClass.className, bundle: nil), forCellWithReuseIdentifier: cellClass.className)
    }
    
    public func dequeue<T: ClassName>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as! T
    }
}
