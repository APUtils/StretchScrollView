//
//  CGRect+Utils.swift
//  StretchScrollView
//
//  Created by Anton Plebanovich on 1/14/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation


extension CGRect {
    /// Center point
    var _center: CGPoint {
        get {
            return CGPoint(x: midX, y: midY)
        }
        set {
            origin.x = newValue.x - width / 2
            origin.y = newValue.y - height / 2
        }
    }
}
