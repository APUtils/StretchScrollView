//
//  UIImage+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 9/20/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension UIImage {
    public func image(withOverlayImage overlayImage: UIImage, inRect rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        draw(at: CGPoint(x: 0, y: 0))
        overlayImage.draw(in: rect)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            return image
        } else {
            return self
        }
    }
}
