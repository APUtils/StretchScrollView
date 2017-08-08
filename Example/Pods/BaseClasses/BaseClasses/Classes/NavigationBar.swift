//
//  NavigationBar.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 8/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit


open class NavigationBar: UINavigationBar {
    
    //-----------------------------------------------------------------------------
    // MARK: - UIView Methods
    //-----------------------------------------------------------------------------
    
    // Make navigation bar transparent for touches so user could scroll over it if it's translucent
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        if result == self && isTranslucent && point.x > 100 { return nil }
        
        return result
    }
}
