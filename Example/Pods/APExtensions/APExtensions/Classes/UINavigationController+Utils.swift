//
//  UINavigationController+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 6/6/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension UINavigationController {
    public var rootViewController: UIViewController {
        get {
            return viewControllers.first!
        }
    }
}
