//
//  UIStoryboard+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 13/03/16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension UIStoryboard {
    /// Instantiates initial view controller from storyboard
    public class func controller(storyboardName: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        
        return controller
    }
}
