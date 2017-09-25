//
//  Array+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 09.08.16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import Foundation


public extension Array {
    /// Second element in array
    public var second: Element? {
        guard count > 1 else { return nil }
        
        return self[1]
    }
}

//-----------------------------------------------------------------------------
// MARK: - Scripting
//-----------------------------------------------------------------------------

public extension Array {
    /// Helper method to modify all value type objects in array
    public mutating func modifyForEach(_ body: (_ index: Index, _ element: inout Element) -> ()) {
        for index in indices {
            modifyElement(atIndex: index) { body(index, &$0) }
        }
    }
    
    /// Helper method to modify value type objects in array at specific index
    public mutating func modifyElement(atIndex index: Index, _ modifyElement: (_ element: inout Element) -> ()) {
        var element = self[index]
        modifyElement(&element)
        self[index] = element
    }
    
    /// Helper method to filter out duplicates. Element will be filtered out if closure return true.
    public func filterDuplicates(_ includeElement: @escaping (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {
        var results = [Element]()
        
        forEach { element in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
    
    public func enumerateForEach(_ body: (_ index: Index, _ element: Element) -> ()) {
        for index in indices {
            body(index, self[index])
        }
    }
}

//-----------------------------------------------------------------------------
// MARK: - Splitting
//-----------------------------------------------------------------------------

public extension Array {
    /// Splits array into slices of specified size
    public func splittedArray(splitSize: Int) -> [[Element]] {
        if self.count <= splitSize {
            return [self]
        } else {
            return [Array<Element>(self[0..<splitSize])] + splittedArray(Array<Element>(self[splitSize..<self.count]), splitSize: splitSize)
        }
    }
    
    private func splittedArray<T>(_ s: [T], splitSize: Int) -> [[T]] {
        if s.count <= splitSize {
            return [s]
        } else {
            return [Array<T>(s[0..<splitSize])] + splittedArray(Array<T>(s[splitSize..<s.count]), splitSize: splitSize)
        }
    }
}
