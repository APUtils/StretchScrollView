//
//  SetupOnce.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 7/18/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

/// Simplifies work with classes that need some routine to be performed once on app load.
/// Using property assures code will never be executed twice.
///
///     static var setupOnce: Int = {
///         // This code will be called once on app start
///         return 0
///     }()
@objc public protocol SetupOnce {
    static var setupOnce: Int { get }
}
