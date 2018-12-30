//
//  Timer+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 4/25/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import Foundation


@available(iOS 10.0, *)
extension Timer {
    /// Returns timer that fires at each minute start
    static func scheduledMinuteStartTimer(action: @escaping (Timer) -> Void) -> Timer {
        // Getting next minute start date
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        components.minute = (components.minute ?? 0) + 1
        
        let date = Calendar.current.date(from: components) ?? Date()
        let timer = Timer(fire: date, interval: 60, repeats: true, block: action)
        RunLoop.main.add(timer, forMode: .common)
        
        return timer
    }
}
