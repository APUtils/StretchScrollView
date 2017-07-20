//
//  Configurable.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 6/16/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


public protocol Configurable {
    /// Usually cells might conform to this protocol so we just can pass view model without typecasting.
    func configure(model: Any)
}
