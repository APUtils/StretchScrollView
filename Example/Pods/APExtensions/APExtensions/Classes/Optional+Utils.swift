//
//  Optional+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 08.08.16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import Foundation

//-----------------------------------------------------------------------------
// MARK: - isNilOrEmpty CollectionType
//-----------------------------------------------------------------------------

public extension Optional where Wrapped: Collection {
    /// Check if object is nil or empty
    public var isNilOrEmpty: Bool {
        if let value = self, !value.isEmpty {
            return false
        } else {
            return true
        }
    }
}

//-----------------------------------------------------------------------------
// MARK: - isNilOrEmpty String
//-----------------------------------------------------------------------------

public protocol EmptyString {
    var isEmpty: Bool { get }
}

extension String: EmptyString {}

public extension Optional where Wrapped: EmptyString {
    /// Check if object is nil or empty
    public var isNilOrEmpty: Bool {
        if let value = self, !value.isEmpty {
            return false
        } else {
            return true
        }
    }
}

//-----------------------------------------------------------------------------
// MARK: - Optional Arrays Equatable
//-----------------------------------------------------------------------------

public func ==<T>(lhs: [T]?, rhs: [T]?) -> Bool where T: Equatable {
    switch (lhs, rhs) {
    case (.none, .none): return true
    case (.some(let lhsValue), .some(let rhsValue)): return lhsValue == rhsValue
    default: return false
    }
}

public func !=<T>(lhs: [T]?, rhs: [T]?) -> Bool where T: Equatable {
    switch (lhs, rhs) {
    case (.none, .none): return false
    case (.some(let lhsValue), .some(let rhsValue)): return lhsValue != rhsValue
    default: return true
    }
}
