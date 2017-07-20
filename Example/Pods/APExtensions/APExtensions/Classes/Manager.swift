//
//  Manager.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 7/18/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//


/// Simplifies Managers start and reset routine. All managers could be then started/reseted on apropriate point in app, e.g. on user login/logout.
public protocol Manager {
    /// Start manager. Usually on app start or user login.
    static func start()
    
    /// Reset manager state. Common patter is to clean userDefaults/database manager records and reassign shared variable. Usually on user logout.
    static func reset()
}
