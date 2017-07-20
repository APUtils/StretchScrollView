//
//  NSCoder+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 7/4/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


public extension NSCoder {
    public func decodeBool(forKey key: String, defaultValue: Bool) -> Bool {
        return (decodeObject(forKey: key) as? Bool) ?? defaultValue
    }
    
    public func decodeDate(forKey key: String, defaultValue: Date) -> Date {
        return (decodeObject(forKey: key) as? Date) ?? defaultValue
    }
    
    public func decodeDouble(forKey key: String, defaultValue: Double) -> Double {
        return (decodeObject(forKey: key) as? Double) ?? defaultValue
    }
    
    public func decodeInt(forKey key: String, defaultValue: Int) -> Int {
        return (decodeObject(forKey: key) as? Int) ?? defaultValue
    }
    
    public func decodeString(forKey key: String, defaultValue: String) -> String {
        return (decodeObject(forKey: key) as? String) ?? defaultValue
    }
    
    public func decodeStringsArray(forKey key: String, defaultValue: [String]) -> [String] {
        return (decodeObject(forKey: key) as? [String]) ?? defaultValue
    }
}
