//
//  PassTouchesView.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 1/9/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import UIKit


/// View that does not block touches and passes them through.
open class PassTouchesView: UIView {
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        if result == self { return nil }
        
        return result
    }
}
