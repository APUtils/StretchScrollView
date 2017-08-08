//
//  Dictionary+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 16.08.16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import Foundation

//-----------------------------------------------------------------------------
// MARK: - Easy dictionary merge
//-----------------------------------------------------------------------------

public func += <K, V> (left: inout [K: V], right: [K: V]?) {
    guard let right = right else { return }
    
    for (k, v) in right {
        left[k] = v
    }
}

//-----------------------------------------------------------------------------
// MARK: - Scripting
//-----------------------------------------------------------------------------

public extension Dictionary {
    /// Helper method to modify value at specific key
    public mutating func modifyValue(atKey key: Key, _ modifyValue: (_ element: inout Value?) -> ()) {
        var value = self[key]
        modifyValue(&value)
        self[key] = value
    }
}

//-----------------------------------------------------------------------------
// MARK: - Values for key
//-----------------------------------------------------------------------------

public extension Dictionary {
    public func int(forKey key: Key) -> Int? {
        if let int = self[key] as? Int {
            return int
        } else if let number = self[key] as? NSNumber {
             return number.intValue
        } else if let string = self[key] as? String {
            return Int(string)
        } else if let double = self[key] as? Double {
            return Int(double)
        } else {
            return nil
        }
    }
    
    public func double(forKey key: Key, defaultValue: Double) -> Double {
        return double(forKey: key) ?? defaultValue
    }
    
    public func double(forKey key: Key) -> Double? {
        if let double = self[key] as? Double {
            return double
        } else if let number = self[key] as? NSNumber {
            return number.doubleValue
        } else if let string = self[key] as? String {
            return Double(string)
        } else if let int = self[key] as? Int {
            return Double(int)
        } else {
            return nil
        }
    }
    
    public func bool(forKey key: Key) -> Bool? {
        if let bool = self[key] as? Bool {
            return bool
        } else if let number = self[key] as? NSNumber {
            return number.boolValue
        } else if let string = self[key] as? NSString {
            return string.boolValue
        } else if let int = self[key] as? Int {
            return (int == 0) ? false : true
        } else if let double = self[key] as? Double {
            return (double == 0.0) ? false : true
        } else {
            return nil
        }
    }
    
    public func string(forKey key: Key, defaultValue: String) -> String {
        return string(forKey: key) ?? defaultValue
    }
    
    public func string(forKey key: Key) -> String? {
        if let string = self[key] as? String {
            return string
        } else if let number = self[key] as? NSNumber {
            return number.stringValue
        } else if let double = self[key] as? Double {
            return String(double)
        } else if let int = self[key] as? Int {
            return String(int)
        } else {
            return nil
        }
    }
    
    public func date(forKey key: Key) -> Date? {
        if let date = self[key] as? Date {
            return date
        } else if let double = self.double(forKey: key) {
            return Date(timeIntervalSince1970: double)
        } else {
            return nil
        }
    }
    
    public func url(forKey key: Key) -> URL? {
        if let url = self[key] as? URL {
            return url
        } else if let string = self[key] as? String, !string.isEmpty {
            return URL(string: string)
        } else {
            return nil
        }
    }
    
    public func data(forKey key: Key) -> Data? {
        if let data = self[key] as? Data {
            return data
        } else {
            return nil
        }
    }
    
    public func dictionary(forKey key: Key) -> [String: AnyObject]? {
        if let dictionary = self[key] as? [String: AnyObject] {
            return dictionary
        } else {
            return nil
        }
    }
}
