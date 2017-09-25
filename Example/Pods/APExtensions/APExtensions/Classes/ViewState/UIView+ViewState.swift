//
//  UIView+ViewState.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 8/22/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

//-----------------------------------------------------------------------------
// MARK: - Responder Helpers
//-----------------------------------------------------------------------------

private var becomeFirstResponderOnViewDidAppearAssociationKey = 0

public extension UIView {
    private var _viewController: UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
    
    private var _becomeFirstResponderOnViewDidAppear: Bool {
        get {
            return objc_getAssociatedObject(self, &becomeFirstResponderOnViewDidAppearAssociationKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &becomeFirstResponderOnViewDidAppearAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Tells view to become first responder only after view did appear.
    ///
    /// Quote from Apple doc: "Never call this method on a view that is not part of an active view hierarchy. You can determine whether the view is onscreen, by checking its window property. If that property contains a valid window, it is part of an active view hierarchy. If that property is nil, the view is not part of a valid view hierarchy."
    ///
    /// Because configuration usually is made in `viewDidLoad` or `viewWillAppear` while `view` still might have `nil` `window` it's useful to delay `becomeFirstResponder` calls.
    @IBInspectable public var becomeFirstResponderOnViewDidAppear: Bool {
        get {
            return _becomeFirstResponderOnViewDidAppear
        }
        set {
            guard newValue != becomeFirstResponderOnViewDidAppear else { return }
            
            _becomeFirstResponderOnViewDidAppear = newValue
            
            if newValue {
                let becomeFirstResponderOnViewDidAppearClosure: (UIViewController?) -> () = { [weak self] viewController in
                    guard let `self` = self, let viewController = viewController, self._becomeFirstResponderOnViewDidAppear else { return }
                    
                    if viewController.viewState == .didAppear {
                        // Already appeared
                        self._becomeFirstResponderOnViewDidAppear = false
                        self.becomeFirstResponder()
                    } else {
                        // Wait until appeared
                        NotificationCenter.default.addObserver(self, selector: #selector(self.onViewDidAppear(notification:)), name: .UIViewControllerViewDidAppear, object: viewController)
                    }
                }
                
                if let viewController = _viewController {
                    becomeFirstResponderOnViewDidAppearClosure(viewController)
                } else {
                    // No viewController means it's initialization from storyboard. Have to wait.
                    DispatchQueue.main.async {
                        becomeFirstResponderOnViewDidAppearClosure(self._viewController)
                    }
                }
            } else {
                NotificationCenter.default.removeObserver(self, name: .UIViewControllerViewDidAppear, object: _viewController)
            }
        }
    }
    
    @objc private func onViewDidAppear(notification: Notification) {
         // Reset this flag so we can assign it again later if needed
        _becomeFirstResponderOnViewDidAppear = false
        
        NotificationCenter.default.removeObserver(self, name: .UIViewControllerViewDidAppear, object: _viewController)
        becomeFirstResponder()
    }
}
