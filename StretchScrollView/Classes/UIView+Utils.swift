//
//  UIView+Utils.swift
//  StretchScrollView
//
//  Created by Anton Plebanovich on 8/8/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


extension UIView {
    /// Returns closest UIViewController from responders chain.
    var _viewController: UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
}
