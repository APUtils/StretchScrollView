//
//  UIViewController+Storyboard.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 7/26/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

//-----------------------------------------------------------------------------
// MARK: - Keyboard
//-----------------------------------------------------------------------------

private var hideRecognizerAssociationKey = 0

public extension UIViewController {
    private var hideRecognizer: UITapGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, &hideRecognizerAssociationKey) as? UITapGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &hideRecognizerAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Allows to hide keyboard when touch outside
    @IBInspectable public var hideKeyboardOnTouch: Bool {
        get {
            return hideRecognizer != nil
        }
        set {
            if newValue {
                if hideRecognizer == nil {
                    let hideRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.endEditing))
                    hideRecognizer.cancelsTouchesInView = false
                    self.hideRecognizer = hideRecognizer
                    
                    if isViewLoaded {
                        view.addGestureRecognizer(hideRecognizer)
                    } else {
                        var notificationToken: NSObjectProtocol!
                        notificationToken = g_sharedNotificationCenter.addObserver(forName: .UIViewControllerViewDidLoad, object: nil, queue: nil, using: { [weak self] n in
                            g_sharedNotificationCenter.removeObserver(notificationToken)
                            
                            if let hideRecognizer = self?.hideRecognizer {
                                self?.view.addGestureRecognizer(hideRecognizer)
                            }
                        })
                    }
                }
            } else {
                if let hideRecognizer = hideRecognizer {
                    view.removeGestureRecognizer(hideRecognizer)
                    self.hideRecognizer = nil
                }
            }
        }
    }
}
