//
//  ClassNameProtocol.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 6/14/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation

/// Helps to print all object fields and values
public protocol Describable: CustomStringConvertible {}

public extension Describable {
    public var description: String {
        var description = ""
        
        let mirror = Mirror(reflecting: self)
        for children in mirror.children {
            description.append(valueName: children.label, value: children.value)
        }
        
        description.wrap(class: type(of: self))
        
        return description
    }
}
