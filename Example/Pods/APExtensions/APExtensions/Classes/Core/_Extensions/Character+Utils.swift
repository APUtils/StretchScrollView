//
//  Character+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 8/4/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


public extension Character {
    public var isUpperCase: Bool {
        return String(self) == String(self).uppercased()
    }
}
