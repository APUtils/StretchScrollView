//
//  UIButton+Storyboard.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 22.02.16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit

//-----------------------------------------------------------------------------
// MARK: - Screen Fit
//-----------------------------------------------------------------------------

private var defaultFontAssociationKey = 0

public extension UIButton {
    private var defaultFont: UIFont? {
        get {
            return objc_getAssociatedObject(self, &defaultFontAssociationKey) as? UIFont
        }
        set {
            objc_setAssociatedObject(self, &defaultFontAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Scale button title font for screen
    @IBInspectable public var fitScreenSize: Bool {
        get {
            return self.defaultFont != nil
        }
        set {
            if newValue {
                // Scale if isn't yet
                guard defaultFont == nil else { return }
                
                defaultFont = titleLabel?.font
                titleLabel?.font = titleLabel?.font.screenFitFont
            } else {
                // Restore
                if let defaultFont = defaultFont {
                    titleLabel?.font = defaultFont
                    self.defaultFont = nil
                }
            }
        }
    }
}

//-----------------------------------------------------------------------------
// MARK: - Label
//-----------------------------------------------------------------------------

public extension UIButton {
    /// Underlying label number of lines
    @IBInspectable public var lines: Int {
        get {
            return titleLabel?.numberOfLines ?? 1
        }
        set {
            titleLabel?.numberOfLines = newValue
        }
    }
}
