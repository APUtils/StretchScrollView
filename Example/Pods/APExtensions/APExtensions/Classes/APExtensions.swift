//
//  APExtensions.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 07/10/2017.
//  Copyright (c) 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


public class APExtensions {
    /// Prepare extensions. Should be called before any extentions is used. Usually in application delegate method `didFinishLaunchingWithOptions`.
    public static func prepare() {
        _ = UIViewController._setupOnce
    }
}
