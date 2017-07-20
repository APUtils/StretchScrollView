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
    var previousViewController: UIViewController? {
        guard let navigationViewControllers = navigationController?.viewControllers else { return nil }
        
        let previousViewControllerIndex = navigationViewControllers.count - 2
        if previousViewControllerIndex >= 0 {
            return navigationViewControllers[previousViewControllerIndex]
        } else {
            return nil
        }
    }
    
    @IBAction func removeViewController(sender: Any) {
        removeViewController(animated: true)
    }
    
    func removeViewController(animated: Bool) {
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
// MARK: - Activity Indicator
//-----------------------------------------------------------------------------

private var showCounterKey = 0

public extension UIViewController {
    private var showCounter: Int {
        get {
            return (objc_getAssociatedObject(self, &showCounterKey) as? Int) ?? 0
        }
        set {
            objc_setAssociatedObject(self, &showCounterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showActivityIndicator() {
        showCounter += 1
        
        var activityIndicator: UIActivityIndicatorView! = view.subviews.flatMap({ $0 as? UIActivityIndicatorView }).last
        if activityIndicator == nil { activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray) }
        
        view.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        
        if !activityIndicator.isAnimating {
            activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        showCounter -= 1
        
        if showCounter <= 0 {
            let activityIndicator = view.subviews.flatMap({ $0 as? UIActivityIndicatorView }).first
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
        }
    }
}
