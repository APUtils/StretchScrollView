//
//  NavigationController.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 5/29/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


/// NavigationControler that pays attantion to its child controlers for status bar style
open class NavigationController: UINavigationController {
    
    //-----------------------------------------------------------------------------
    // MARK: - UIViewController Methods
    //-----------------------------------------------------------------------------
    
    override open var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
