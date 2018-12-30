//
//  ClassName.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 6/8/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation

/// Allows to get class name string
public protocol ClassName {
    /// Class name string
    @nonobjc static var className: String { get }
    
    /// Class name string
    @nonobjc var className: String { get }
}

public extension ClassName {
    @nonobjc static var className: String {
        return String(describing: self)
    }
    
    @nonobjc var className: String {
        return String(describing: type(of: self))
    }
}

extension NSObject: ClassName {}
