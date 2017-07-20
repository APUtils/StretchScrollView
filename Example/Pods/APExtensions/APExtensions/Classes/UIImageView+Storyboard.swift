//
//  UIImage+Storyboard.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 22.02.16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit

//-----------------------------------------------------------------------------
// MARK: - Screen Fit
//-----------------------------------------------------------------------------

/// Do not store previous image because it could cause memory hit
private let keepPreviousImage = false
private var defaultImageAssociationKey = 0

public extension UIImageView {
    private var defaultImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &defaultImageAssociationKey) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &defaultImageAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Scale image for screen
    @IBInspectable var fitScreenSize: Bool {
        get {
            return defaultImage != nil
        }
        set {
            if newValue {
                guard let oldImage = image else { return }
                guard UIScreen.main.scale == 2 else { return } // Ignore 1x and 3x screens
                
                // Assuming we don't have 2x image in assets folder. 6+ size is 1242x2208.
                let resizeCoef = UIScreen.main.bounds.width * UIScreen.main.scale / 1242
                let newImageSize = CGSize(width: oldImage.size.width * resizeCoef, height: oldImage.size.height * resizeCoef)
                
                // Resizing image
                UIGraphicsBeginImageContextWithOptions(newImageSize, false, 0); // 0 == device main screen scale
                let context = UIGraphicsGetCurrentContext()
                context?.interpolationQuality = .high
                oldImage.draw(in: CGRect(x: 0, y: 0, width: newImageSize.width, height: newImageSize.height))
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                if keepPreviousImage {
                    defaultImage = oldImage
                }
                
                image = newImage
            } else {
                // Restore
                if let defaultImage = defaultImage {
                    image = defaultImage
                    self.defaultImage = nil
                }
            }
        }
    }
}

//-----------------------------------------------------------------------------
// MARK: - Localized Image
//-----------------------------------------------------------------------------

private var localizedImageNameAssociationKey = 0

public extension UIImageView {
    private var localizedImageName: String? {
        get {
            return objc_getAssociatedObject(self, &localizedImageNameAssociationKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &localizedImageNameAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Using localized "_en" key to append to image. Won't work if you don't have "_en" key in your localized strings.
    /// In case you need to change image programmatically - set this property to `nil` first
    @IBInspectable var localizableImageName: String? {
        get {
            return localizedImageName
        }
        set {
            if let newValue = newValue {
                let localizedImageName = newValue + g_Translate("_en")
                self.localizedImageName = localizedImageName
                
                image = UIImage(named: localizedImageName)
            } else {
                localizedImageName = nil
                image = nil
            }
        }
    }
}
