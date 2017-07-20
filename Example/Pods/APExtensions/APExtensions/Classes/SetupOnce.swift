//
//  SetupOnce.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 7/18/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

/// Simplifies work with classes that need some routine to be performed once during app lifecycle.
/// You then declares variable like this:
///
///     static var _setupOnce: () = setupOnce()
///     private static func setupOnce() {}
public protocol SetupOnce {
    static var setupOnce: Void { get }
}
