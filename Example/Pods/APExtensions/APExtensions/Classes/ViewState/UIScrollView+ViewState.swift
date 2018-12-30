//
//  UIScrollView+ViewState.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 12/7/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

// ******************************* MARK: - Responder Helpers

private var flashScrollIndicatorsOnViewDidAppearAssociationKey = 0


public extension UIScrollView {
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
    
    private var _flashScrollIndicatorsOnViewDidAppear: Bool {
        get {
            return objc_getAssociatedObject(self, &flashScrollIndicatorsOnViewDidAppearAssociationKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &flashScrollIndicatorsOnViewDidAppearAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Tells scroll view to flash its scroll indicators in view did appear.
    @IBInspectable public var flashScrollIndicatorsOnViewDidAppear: Bool {
        get {
            return _flashScrollIndicatorsOnViewDidAppear
        }
        set {
            guard newValue != flashScrollIndicatorsOnViewDidAppear else { return }
            
            _flashScrollIndicatorsOnViewDidAppear = newValue
            
            if newValue {
                let becomeFirstResponderOnViewDidAppearClosure: (UIViewController?) -> () = { [weak self] viewController in
                    guard let `self` = self, let viewController = viewController, self._flashScrollIndicatorsOnViewDidAppear else { return }
                    
                    if viewController.viewState == .didAppear {
                        // Already appeared
                        self._flashScrollIndicatorsOnViewDidAppear = false
                        self.becomeFirstResponder()
                    } else {
                        // Wait until appeared
                        var token: NSObjectProtocol!
                        token = NotificationCenter.default.addObserver(forName: .UIViewControllerViewDidAppear, object: viewController, queue: nil) { [weak self] _ in
                            NotificationCenter.default.removeObserver(token)
                            guard let `self` = self else { return }
                            // Reset this flag so we can assign it again later if needed
                            self._flashScrollIndicatorsOnViewDidAppear = false
                            self.flashScrollIndicators()
                        }
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
}
