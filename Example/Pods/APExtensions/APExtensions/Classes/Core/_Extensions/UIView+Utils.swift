//
//  UIView+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 28/05/16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit

// ******************************* MARK: - Sizes

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

// ******************************* MARK: - Animations

public extension UIView {
    /// Checks if code runs inside animation closure
    @available(iOS 9.0, *)
    public static var isInAnimationClosure: Bool {
        return inheritedAnimationDuration > 0
    }
    
    public func fadeInAnimated() {
        guard alpha != 1 else { return }
        
        g_animate { self.alpha = 1 }
    }
    
    public func fadeOutAnimated() {
        guard alpha != 0 else { return }
        
        g_animate { self.alpha = 0 }
    }
}

// ******************************* MARK: - Utils

public extension UIView {
    /// Makes corner radius euqal to half of width or height
    public func makeRound() {
        layer.cornerRadius = min(width, height) / 2
    }
    
    /// Returns closest UIViewController from responders chain.
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

// ******************************* MARK: - Sequence

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

// ******************************* MARK: - Image

public extension UIView {
    /// Creates image from view and adds overlay image at the center if provided
    public func getSnapshotImage(overlayImage: UIImage? = nil) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        if let overlayImage = overlayImage {
            let imageWidth = overlayImage.size.width
            let imageHeight = overlayImage.size.height
            let imageRect = CGRect(x: bounds.midX - imageWidth / 2, y: bounds.midY - imageHeight / 2, width: imageWidth, height: imageHeight)
            overlayImage.draw(in: imageRect)
        }
        
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        return snapshotImage
    }
}

// ******************************* MARK: - Responder Helpers

public extension UIView {
    /// Ends editing on view and all of it's subviews
    @IBAction public func endEditing() {
        endEditing(true)
    }
    
    /// Checks if window is not nil before calling becomeFirstResponder()
    public func becomeFirstResponderIfPossible() {
        guard window != nil else { return }
        
        becomeFirstResponder()
    }
}

// ******************************* MARK: - Activity Indicator

private var showCounterKey = 0

public extension UIView {
    private var showCounter: Int {
        get {
            return (objc_getAssociatedObject(self, &showCounterKey) as? Int) ?? 0
        }
        set {
            objc_setAssociatedObject(self, &showCounterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Is activity indicator showing?
    public var isShowingActivityIndicator: Bool {
        return showCounter > 0
    }
    
    /// Shows activity indicator.
    /// It uses existing one if found in subviews.
    /// Calls to -showActivityIndicator and -hideActivityIndicator have to be balanced or hide have to be forced.
    public func showActivityIndicator() {
        showCounter += 1
        
        var activityIndicator: UIActivityIndicatorView! = subviews.compactMap({ $0 as? UIActivityIndicatorView }).last
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            activityIndicator.color = .lightGray
            addSubview(activityIndicator)
            activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
            activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        }
        activityIndicator.superview?.bringSubviewToFront(activityIndicator)
        
        if !activityIndicator.isAnimating {
            activityIndicator.startAnimating()
        }
    }
    
    /// Hides activity indicator.
    /// Calls to -showActivityIndicator and -hideActivityIndicator have to be balanced or hide have to be forced.
    /// - parameters:
    ///   - force: Force activity indicator hide
    public func hideActivityIndicator(force: Bool = false) {
        if force {
            showCounter = 0
        } else {
            showCounter -= 1
        }
        
        if showCounter <= 0 {
            let activityIndicator = subviews.compactMap({ $0 as? UIActivityIndicatorView }).first
            activityIndicator?.stopAnimating()
            
            showCounter = 0
        }
    }
}
