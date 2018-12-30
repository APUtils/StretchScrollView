//
//  UIBarButtonItem+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 12/15/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


private var defaultTintColorAssociationKey = 0


public extension UIBarButtonItem {
    private var defaultTintColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &defaultTintColorAssociationKey) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &defaultTintColorAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var isHidden: Bool {
        get {
            return tintColor == .clear && isEnabled == false
        }
        set(_isHidden) {
            guard _isHidden != isHidden else { return }
            
            if _isHidden {
                defaultTintColor = tintColor
                tintColor = .clear
                isEnabled = false
            } else {
                if isEnabled {
                    // Already visible
                } else {
                    isEnabled = true
                    tintColor = defaultTintColor
                }
            }
        }
    }
}
