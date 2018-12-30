//
//  UIApplication+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 7/14/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

// ******************************* MARK: - Phone Call

public extension UIApplication {
    /// Initiates call to `phone`
    public static func makeCall(phone: String) {
        let urlString = "telprompt://\(phone)"
        guard let url = URL(string: urlString) else { return }
        
        shared.openURL(url)
    }
}

// ******************************* MARK: - Background Task

private var v_backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid

public extension UIApplication {
    /// Starts background task if app is in background and task is not yet started.
    public func startBackgroundTaskIfNeeded() {
        guard UIApplication.shared.applicationState == .background else { return }
        guard v_backgroundTaskIdentifier == .invalid else { return }
        
        v_backgroundTaskIdentifier = beginBackgroundTask {
            self.stopBackgroundTaskIfNeeded()
        }
    }
    
    /// Stops background task if not yet stopped.
    public func stopBackgroundTaskIfNeeded() {
        guard v_backgroundTaskIdentifier != .invalid else { return }
        
        endBackgroundTask(v_backgroundTaskIdentifier)
        v_backgroundTaskIdentifier = .invalid
    }
}
