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
    /// View width
    public var width: CGFloat {
        get {
            return bounds.width
        }
        set {
            bounds.size.width = newValue
        }
    }
    
    /// View height
    public var height: CGFloat {
        get {
            return bounds.height
        }
        set {
            bounds.size.height = newValue
        }
    }
    
    /// View size
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
// MARK: - Animations
//-----------------------------------------------------------------------------

public extension UIView {
    public func fadeInAnimated() {
        g_animate { self.alpha = 1 }
    }
    
    public func fadeOutAnimated() {
        g_animate { self.alpha = 0 }
    }
}

//-----------------------------------------------------------------------------
// MARK: - Utils
//-----------------------------------------------------------------------------

public extension UIView {
    /// Makes corner radius euqal to half of width or height
    public func makeRound() {
        cornerRadius = min(width, height) / 2
    }
    
    /// Returns view's UIViewController.
    public var viewController: UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
    
    /// Gets view's top most superview
    public var rootView: UIView {
        return superview?.rootView ?? self
    }
}

//-----------------------------------------------------------------------------
// MARK: - Sequence
//-----------------------------------------------------------------------------

public extension UIView {
    /// Returns all view's subviews
    public var allSubviews: [UIView] {
        var allSubviews = self.subviews
        
        allSubviews.forEach { allSubviews.append(contentsOf: $0.allSubviews) }
        
        return allSubviews
    }
    
    /// All view superviews to the top most
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
    /// Ends editing on view and all of it's subviews
    public func endEditing() {
        endEditing(true)
    }
    
    /// Tells view to become first responder only after view did appear for provided controller. Might be useful to prevent broken push animation.
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
