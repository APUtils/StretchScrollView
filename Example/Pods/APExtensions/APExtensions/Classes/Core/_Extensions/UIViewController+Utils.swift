//
//  UIViewController+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 28/05/16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit

//-----------------------------------------------------------------------------
// MARK: - Navigation
//-----------------------------------------------------------------------------

public extension UIViewController {
    /// Previous view controller in navigation stack
    public var previousViewController: UIViewController? {
        guard let navigationViewControllers = navigationController?.viewControllers, let currentVcIndex = navigationViewControllers.index(of: self) else { return nil }
        
        let previousViewControllerIndex = currentVcIndex - 1
        if previousViewControllerIndex >= 0 {
            return navigationViewControllers[previousViewControllerIndex]
        } else {
            return nil
        }
    }
    
    public var isBeingRemoved: Bool {
        return isMovingFromParentViewController || isBeingDismissed || (navigationController?.isBeingDismissed ?? false)
    }
    
    /// Remove view controller animated action. Removes using pop if it was pushed or using dismiss if it was presented.
    @IBAction func removeViewController(sender: Any) {
        removeViewController(animated: true)
    }
    
    /// Removes view controller using pop if it was pushed or using dismiss if it was presented.
    public func removeViewController(animated: Bool) {
        if navigationController?.viewControllers.first == self {
            dismiss(animated: animated, completion: nil)
        } else if navigationController?.viewControllers.last == self {
            navigationController?.popViewController(animated: true)
        } else if presentingViewController != nil {
            dismiss(animated: animated, completion: nil)
        }
    }
}

//-----------------------------------------------------------------------------
// MARK: - Editing
//-----------------------------------------------------------------------------

public extension UIViewController {
    /// End editing in viewController's view
    @IBAction func endEditing(_ sender: Any) {
        view.endEditing()
    }
}
