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
    
    /// Returns random element from array
    public var random: Element? {
        guard !isEmpty else { return nil }
        
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
    
    /// Replaces last element with new element and returns replaced element.
    @discardableResult
    public mutating func replaceLast(_ element: Element) -> Element {
        let lastElement = removeLast()
        append(element)
        
        return lastElement
    }
}

// ******************************* MARK: - Scripting

public extension Array {
    /// Helper method to modify all value type objects in array
    public mutating func modifyForEach(_ body: (_ index: Index, _ element: inout Element) throws -> ()) rethrows {
        for index in indices {
            try modifyElement(atIndex: index) { try body(index, &$0) }
        }
    }
    
    /// Helper method to modify value type objects in array at specific index
    public mutating func modifyElement(atIndex index: Index, _ modifyElement: (_ element: inout Element) throws -> ()) rethrows {
        var element = self[index]
        try modifyElement(&element)
        self[index] = element
    }
    
    /// Helper method to enumerate all objects in array together with index
    public func enumerateForEach(_ body: (_ index: Index, _ element: Element) throws -> ()) rethrows {
        for index in indices {
            try body(index, self[index])
        }
    }
    
    /// Helper method to map all objects in array together with index
    public func enumerateMap<T>(_ body: (_ index: Index, _ element: Element) throws -> T) rethrows -> [T] {
        var map: [T] = []
        for index in indices {
            map.append(try body(index, self[index]))
        }
        
        return map
    }
    
    /// Helper methods to remove object using closure
    @discardableResult public mutating func remove(_ body: (_ element: Element) throws -> Bool) rethrows -> Element? {
        guard let index = try index(where: body) else { return nil }
        
        return remove(at: index)
    }
    
    /// Helper method to filter out duplicates. Element will be filtered out if closure return true.
    public func filterDuplicates(_ includeElement: (_ lhs: Element, _ rhs: Element) throws -> Bool) rethrows -> [Element] {
        var results = [Element]()
        
        try forEach { element in
            let existingElements = try results.filter {
                return try includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
    
    /// Transforms an array to a dictionary using array elements as keys and transform result as values.
    func dictionaryMap<T>(_ transform:(_ element: Iterator.Element) throws -> T?) rethrows -> [Iterator.Element: T] {
        return try self.reduce(into: [Iterator.Element: T]()) { dictionary, element in
            guard let value = try transform(element) else { return }
            
            dictionary[element] = value
        }
    }
    
    /// Groups array elements into dictionary using provided transform to determine element's key.
    func group<K>(_ keyTransform: (Iterator.Element) throws -> K) rethrows -> [K: [Iterator.Element]] {
        var dictionary = [K: [Iterator.Element]]()
        for index in indices {
            let element = self[index]
            let key = try keyTransform(element)
            var array = dictionary[key] ?? []
            array.append(element)
            dictionary[key] = array
        }
        
        return dictionary
    }
    
    public mutating func move(from: Index, to: Index) {
        let element = remove(at: from)
        insert(element, at: to)
    }
}

public extension Array where Element: Equatable {
    /// Helper methods to remove all objects that are equal to passed one.
    public mutating func remove(_ element: Element) {
        while let index = index(of: element) {
            remove(at: index)
        }
    }
}

// ******************************* MARK: - Splitting

public extension Array {
    /// Splits array into slices of specified size
    func splittedArray(splitSize: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: splitSize).map {
            Array(self[$0..<Swift.min($0 + splitSize, count)])
        }
    }
}
