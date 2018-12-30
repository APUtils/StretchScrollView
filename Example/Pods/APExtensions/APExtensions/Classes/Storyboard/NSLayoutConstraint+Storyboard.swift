//
//  NSLayoutConstraint+Storyboard.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 7/12/17.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import Foundation

// ******************************* MARK: - Fit Screen

private let roundConstantSize = false
private var defaultConstantAssociationKey = 0

public extension NSLayoutConstraint {
    private var defaultConstant: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &defaultConstantAssociationKey) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &defaultConstantAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Scale constraint constant to fit screen. Assuming source font is for 2208x1242 screen.
    /// In case you need to change constant value programmatically - reset this flag to false first.
    @IBInspectable public var fitScreenSize: Bool {
        get {
            return defaultConstant != nil
        }
        set {
            if newValue {
                // Scale if isn't yet
                guard defaultConstant == nil else { return }
                
                let baseScreenSize: CGFloat = 414 // iPhone 6+
                let currentScreenSize = UIScreen.main.bounds.width
                let resizeCoef = currentScreenSize / baseScreenSize
                var newConstant = constant * resizeCoef
                if roundConstantSize {
                    newConstant = newConstant.rounded(.toNearestOrEven)
                }
                
                defaultConstant = constant
                constant = newConstant
            } else {
                // Restore
                if let defaultConstant = defaultConstant {
                    constant = defaultConstant
                    self.defaultConstant = nil
                }
            }
        }
    }
}

// ******************************* MARK: - One Pixel Width

public extension NSLayoutConstraint {
    /// Make one pixel size constraint
    @IBInspectable public var onePixelSize: Bool {
        get {
            return constant == 1 / UIScreen.main.scale
        }
        set {
            constant = 1 / UIScreen.main.scale
        }
    }
}
