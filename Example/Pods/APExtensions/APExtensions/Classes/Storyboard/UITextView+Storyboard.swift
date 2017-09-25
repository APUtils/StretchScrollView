//
//  UITextView+Storyboard.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 6/27/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


private var defaultFontAssociationKey = 0


public extension UITextView {
    private var defaultFont: UIFont? {
        get {
            return objc_getAssociatedObject(self, &defaultFontAssociationKey) as? UIFont
        }
        set {
            objc_setAssociatedObject(self, &defaultFontAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Scale font for screen
    @IBInspectable public var fitScreenSize: Bool {
        get {
            return defaultFont != nil
        }
        set {
            if newValue {
                defaultFont = font
                font = font?.screenFitFont
            } else {
                // Restore
                if let defaultFont = defaultFont {
                    font = defaultFont
                    self.defaultFont = nil
                }
            }
        }
    }
}
