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
    /// Get yesterday's day start date. Uses user's time zone.
    public static var yesterday: Date {
        return Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())!.startOfDay
    }
    
    /// Get today's day start date. Uses user's time zone.
    public static var today: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    /// Get tomorrow's day start date. Uses user's time zone.
    public static var tomorrow: Date {
        return Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())!.startOfDay
    }
    
    /// Get day start. Uses user's time zone.
    public var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// Get date's components. Uses user's time zone.
    public var components: DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .timeZone, .calendar], from: self)
    }
    
    /// Returns beginning of the previous day.
    public var previousDay: Date {
        return Calendar.current.date(byAdding: DateComponents(day: -1), to: self)!.startOfDay
    }
    
    /// Returns beginning of the next work day excluding today. It just exludes weekends. Does not exclude holidays.
    public var previousWorkDay: Date {
        var currentDate = previousDay
        
        // Skipping weekends
        while currentDate.isWeekend { currentDate = currentDate.previousDay }
        
        return currentDate
    }
    
    /// Returns beginning of the next day.
    public var nextDay: Date {
        return Calendar.current.date(byAdding: DateComponents(day: 1), to: self)!.startOfDay
    }
    
    /// Returns beginning of the next work day excluding today. It just exludes weekends. Does not exclude holidays.
    public var nextWorkDay: Date {
        var currentDate = nextDay
        
        // Skipping weekends
        while currentDate.isWeekend { currentDate = currentDate.nextDay }
        
        return currentDate
    }
    
    /// Checks if date is in yesterday's range. Uses user's time zone.
    public var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// Checks if date is in today's range. Uses user's time zone.
    public var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Checks if date is in tomorrow's range. Uses user's time zone.
    public var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// Checks if date is in weekend's range. Uses user's time zone.
    public var isWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
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
    public func getString(dateStyle: DateFormatter.Style = .short, timeStyle: DateFormatter.Style = .short, doesRelativeDateFormatting: Bool = true) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
        
        return formatter.string(from: self)
    }
}
