//
//  Data+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 6/12/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


public extension Data {
    public var hexString : String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    public var utf8String: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
    
    public var jsonObject: Any? {
        return try? JSONSerialization.jsonObject(with: self, options: [])
    }
    
    public var jsonDictionary: [String : Any]? {
        return jsonObject as? [String : Any]
    }
    
    public var jsonArray: [Any]? {
        return jsonObject as? [Any]
    }
    
    public func jsonDictionaryStringForKey(_ key: String) -> String? {
        guard let dictionary = jsonDictionary else { return nil }
        
        let value = dictionary[key]
        
        return value as? String
    }
}
