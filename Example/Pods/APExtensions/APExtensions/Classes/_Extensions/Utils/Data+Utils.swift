//
//  Data+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 6/12/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


public extension Data {
    /// Get HEX string from data. Can be for sending APNS toke to backend.
    public var hexString : String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// Try to convert data to UTF8 string
    public var utf8String: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
    
    /// Try to serialize JSON data
    public var jsonObject: Any? {
        return try? JSONSerialization.jsonObject(with: self, options: [])
    }
    
    /// Try to get dictionary from JSON data
    public var jsonDictionary: [String : Any]? {
        return jsonObject as? [String : Any]
    }
    
    /// Try to get array from JSON data
    public var jsonArray: [Any]? {
        return jsonObject as? [Any]
    }
    
    /// Try to get string for key in dictionary from JSON data
    public func jsonDictionaryStringForKey(_ key: String) -> String? {
        guard let dictionary = jsonDictionary else { return nil }
        
        let value = dictionary[key]
        
        return value as? String
    }
}
