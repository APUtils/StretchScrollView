//
//  UIImage+Storyboard.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 8/3/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension UIImage {
    /// Returns screen scaled image. Assuming source image is for 2208x1242 screen.
    public var screenFitImage: UIImage {
        // Assuming we don't have 2x image in assets folder. 6+ size is 1242x2208.
        let resizeCoef = UIScreen.main.bounds.width * UIScreen.main.scale / 1242
        let newImageSize = CGSize(width: size.width * resizeCoef, height: size.height * resizeCoef)
        
        // Resizing image
        UIGraphicsBeginImageContextWithOptions(newImageSize, false, 0); // 0 == device main screen scale
        let context = UIGraphicsGetCurrentContext()
        context?.interpolationQuality = .high
        draw(in: CGRect(x: 0, y: 0, width: newImageSize.width, height: newImageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage?.withRenderingMode(renderingMode) ?? self
    }
}
