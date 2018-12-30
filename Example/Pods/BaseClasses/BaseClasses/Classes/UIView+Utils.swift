//
//  UIView+Utils.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 12/7/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


extension UIView {
    /// Gets view's top most superview
    var _rootView: UIView {
        return superview?._rootView ?? self
    }
}
