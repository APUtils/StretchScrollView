//
//  UICollectionView+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 01/02/2017.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension UICollectionView {
    
    // ******************************* MARK: - Cell Nib
    
    /// Simplifies header registration. Xib name must be the same as class name.
    func registerNib(headerClass: UICollectionReusableView.Type) {
        let nib = UINib(nibName: headerClass.className, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerClass.className)
    }
    
    /// Simplifies footer registration. Xib name must be the same as class name.
    func registerNib(footerClass: UICollectionReusableView.Type) {
        let nib = UINib(nibName: footerClass.className, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerClass.className)
    }
    
    /// Simplifies cell registration. Xib name must be the same as class name.
    func registerNib(cellClass: UICollectionViewCell.Type) {
        register(UINib(nibName: cellClass.className, bundle: nil), forCellWithReuseIdentifier: cellClass.className)
    }
    
    /// Simplifies cell dequeue. Specify type of variable on declaration so proper cell will be dequeued.
    /// Example:
    ///
    ///     let cell: MyCell = collectionView.dequeueCell(for: indexPath)
    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as! T
    }
    
    /// Simplifies configurable cell dequeue.
    ///
    /// Example:
    ///
    ///     let cell = collectionView.dequeueConfigurableCell(class: MyCellClass.self, for: indexPath)
    func dequeueConfigurableCell(class: (UICollectionViewCell & Configurable).Type, for indexPath: IndexPath) -> UICollectionViewCell & Configurable {
        return dequeueReusableCell(withReuseIdentifier: `class`.className, for: indexPath) as! UICollectionViewCell & Configurable
    }
    
    /// Simplifies configurable header dequeue.
    ///
    /// Example:
    ///
    ///     let cell = collectionView.dequeueConfigurableHeader(class: MyHeaderClass.self, for: indexPath)
    func dequeueConfigurableHeader(class: (UICollectionReusableView & Configurable).Type, for indexPath: IndexPath) -> UICollectionReusableView & Configurable {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: `class`.className, for: indexPath) as! UICollectionReusableView & Configurable
    }
    
    /// Simplifies configurable footer dequeue.
    ///
    /// Example:
    ///
    ///     let cell = collectionView.dequeueConfigurableFooter(class: MyFooterClass.self, for: indexPath)
    func dequeueConfigurableFooter(class: (UICollectionReusableView & Configurable).Type, for indexPath: IndexPath) -> UICollectionReusableView & Configurable {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: `class`.className, for: indexPath) as! UICollectionReusableView & Configurable
    }
}
