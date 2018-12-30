//
//  NotificationCenter+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 8/15/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation

// ******************************* MARK: - Day Start Notifications

public extension Notification.Name {
    /// Post on 0:00:00 every day so app can refresh it's data. For example change `Today` to `Yesterday` date formatter string.
    public static let DayDidStart = Notification.Name("DayDidStart")
}


private var dayTimer: Timer?
private var fireDate: Date?


public extension NotificationCenter {
    /// Start day notifications that post on 0:00:00 every day so app can refresh it's data. For example change `Today` to `Yesterday` date formatter string.
    public func startDayNotifications() {
        guard fireDate == nil else { return }
        
        fireDate = Date.tomorrow
        
        // No need to start timer if application is not active, it'll be started when app becomes active
        if UIApplication.shared.applicationState == .active {
            startTimer()
        }
        
        g_sharedNotificationCenter.addObserver(self, selector: #selector(self.onDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        g_sharedNotificationCenter.addObserver(self, selector: #selector(self.onWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    public func stopDayNotifications() {
        g_sharedNotificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        g_sharedNotificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        
        stopTimer()
        
        fireDate = nil
    }
    
    // ******************************* MARK: - Timer
    
    private func startTimer() {
        g_performInMain {
            guard let fireDate = fireDate else { return }
            
            dayTimer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(self.onTimer(_:)), userInfo: nil, repeats: false)
            RunLoop.main.add(dayTimer!, forMode: .default)
        }
    }
    
    private func restartTimer() {
        g_performInMain {
            self.stopTimer()
            
            fireDate = Date.tomorrow
            self.startTimer()
        }
    }
    
    private func stopTimer() {
        g_performInMain {
            dayTimer?.invalidate()
            dayTimer = nil
        }
    }
    
    @objc private func onTimer(_ timer: Timer) {
        g_sharedNotificationCenter.post(name: .DayDidStart, object: self)
        restartTimer()
    }
    
    // ******************************* MARK: - Notifications
    
    @objc private func onDidBecomeActive(_ notification: Notification) {
        if let fireDate = fireDate, fireDate < Date() {
            g_sharedNotificationCenter.post(name: .DayDidStart, object: self)
        }
        
        restartTimer()
    }
    
    @objc private func onWillResignActive(_ notification: Notification) {
        stopTimer()
    }
}
