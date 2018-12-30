//
//  URLComponents+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 12/30/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


extension URLComponents {
    /// Adds query item to other query items
    public mutating func addQueryItem(_ item: URLQueryItem) {
        if queryItems == nil {
            queryItems = [item]
        } else {
            queryItems?.append(item)
        }
    }
}
