//
//  Date+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 6/21/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation

//-----------------------------------------------------------------------------
// MARK: - Components
//-----------------------------------------------------------------------------

public extension Date {
    /// Get today's date. Uses user's time zone.
    public static var today: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    /// Get day start. Uses user's time zone.
    public var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// Get date's components. Uses user's time zone.
    public var components: DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .timeZone, .calendar], from: self)
    }
    
    /// Checks if date is in today's range. Uses user's time zone.
    public var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Checks if date is in tomorrow's range. Uses user's time zone.
    public var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// Converts date to GMT time zone day start.
    public var gmtDayBeginningDate: Date {
        let toGmtTimeInterval = TimeInterval(TimeZone.current.secondsFromGMT(for: self))
        
        return Date(timeInterval: toGmtTimeInterval, since: self)
    }
    
    /// Checks if dates are on same day. Uses user's time zone.
    public func isSameDay(withDate date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
}

//-----------------------------------------------------------------------------
// MARK: - String Representation
//-----------------------------------------------------------------------------

public extension Date {
    /// Simplification of getting string from date
    public func getString(dateStyle: DateFormatter.Style = .short, timeStyle: DateFormatter.Style = .short, doesRelativeDateFormatting: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
        
        return formatter.string(from: self)
    }
}
