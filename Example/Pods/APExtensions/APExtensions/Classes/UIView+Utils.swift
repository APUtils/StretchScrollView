//
//  UIView+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 28/05/16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit

//-----------------------------------------------------------------------------
// MARK: - Sizes
//-----------------------------------------------------------------------------

public extension UIView {
    public var width: CGFloat {
        get {
            return bounds.width
        }
        set {
            bounds.size.width = newValue
        }
    }
    
    public var height: CGFloat {
        get {
            return bounds.height
        }
        set {
            bounds.size.height = newValue
        }
    }
    
    public var size: CGSize {
        get {
            return bounds.size
        }
        set {
            bounds.size = newValue
        }
    }
}

//-----------------------------------------------------------------------------
// MARK: - Utils
//-----------------------------------------------------------------------------

public extension UIView {
    public func makeRound() {
        cornerRadius = min(width, height) / 2
    }
    
    public var rootView: UIView {
        return superview?.rootView ?? self
    }
}

//-----------------------------------------------------------------------------
// MARK: - Sequence
//-----------------------------------------------------------------------------

public extension UIView {
    public var allSubviews: [UIView] {
        var allSubviews = self.subviews
        
        allSubviews.forEach { allSubviews.append(contentsOf: $0.allSubviews) }
        
        return allSubviews
    }
    
    public var superviews: AnySequence<UIView> {
        return sequence(first: self, next: { $0.superview }).dropFirst(1)
    }
}

//-----------------------------------------------------------------------------
// MARK: - Image
//-----------------------------------------------------------------------------

public extension UIView {
    /// Creates image from view and adds overlay image at the center if provided
    public func getSnapshotImage(overlayImage: UIImage? = nil) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        if let overlayImage = overlayImage {
            var imageRect = CGRect(origin: CGPoint(), size: overlayImage.size)
            imageRect.center = bounds.center
            overlayImage.draw(in: imageRect)
        }
        
        let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        return snapshotImage
    }
}

//-----------------------------------------------------------------------------
// MARK: - Responder Helpers
//-----------------------------------------------------------------------------

public extension UIView {
    public func endEditing() {
        endEditing(true)
    }
    
    public func becomeFirstResponderOnViewDidAppear(controller: UIViewController) {
        guard controller.viewState != .didAppear else {
            becomeFirstResponder()
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onViewDidAppear(notification:)), name: .UIViewControllerViewDidAppear, object: controller)
    }
    
    @objc private func onViewDidAppear(notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: .UIViewControllerViewDidAppear, object: nil)
        DispatchQueue.main.async {
            self.becomeFirstResponder()
        }
    }
}
