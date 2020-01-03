//
//  UIViewController+Utils.swift
//  StretchScrollView
//
//  Created by Anton Plebanovich on 8/14/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


extension UIViewController {
    /// Previous view controller in navigation stack
    var _previousViewController: UIViewController? {
        guard let navigationViewControllers = navigationController?.viewControllers, let currentVcIndex = navigationViewControllers.firstIndex(of: self) else { return nil }
        
        let previousViewControllerIndex = currentVcIndex - 1
        if previousViewControllerIndex >= 0 {
            return navigationViewControllers[previousViewControllerIndex]
        } else {
            return nil
        }
    }
}
