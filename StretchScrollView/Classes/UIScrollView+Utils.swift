//
//  UIScrollView+Utils.swift
//  StretchScrollView
//
//  Created by Anton Plebanovich on 1/14/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    /// Bounds center relative to content size
    var _relativeCenter: CGPoint {
        get {
            let relativeCenterX: CGFloat
            if contentSize.width == 0 {
                relativeCenterX = 0
            } else {
                relativeCenterX = bounds._center.x / contentSize.width
            }
            
            let relativeCenterY: CGFloat
            if contentSize.height == 0 {
                relativeCenterY = 0
            } else {
                relativeCenterY = bounds._center.y / contentSize.height
            }
            
            return CGPoint(x: relativeCenterX, y: relativeCenterY)
        }
        
        set {
            let newCenter = CGPoint(x: newValue.x * contentSize.width, y: newValue.y * contentSize.height)
            bounds._center = newCenter
        }
    }
    
    /// Assures that contentOffset value is correct.
    func _clampContentOffset() {
        let minOffsetY = -contentInset.top
        let maxOffsetY = max(contentSize.height - bounds.size.height + contentInset.bottom, 0)
        let minOffsetX = -contentInset.left
        let maxOffsetX = max(contentSize.width - bounds.size.width + contentInset.right, 0)
        
        var newContentOffset = contentOffset
        newContentOffset.y = min(newContentOffset.y, maxOffsetY)
        newContentOffset.y = max(newContentOffset.y, minOffsetY)
        newContentOffset.x = min(newContentOffset.x, maxOffsetX)
        newContentOffset.x = max(newContentOffset.x, minOffsetX)
        
        contentOffset = newContentOffset
    }
    
    func _forceStopScrolling() {
        setContentOffset(contentOffset, animated: false)
    }
}
