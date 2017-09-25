//
//  String+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 16/04/16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit

//-----------------------------------------------------------------------------
// MARK: - Subscript
//-----------------------------------------------------------------------------

public extension String {
    public subscript(i: Int) -> Character {
        let index: Index = self.characters.index(self.startIndex, offsetBy: i)
        return self[index]
    }
    
    public subscript(i: Int) -> String {
        let character: Character = self[i]
        return String(character)
    }
    
    public subscript(range: Range<Int>) -> String {
        let start: Index = characters.index(startIndex, offsetBy: range.lowerBound)
        let end: Index = characters.index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[Range(start ..< end)])
    }
    
    public var first: String {
        return isEmpty ? "" : self[0]
    }
}

//-----------------------------------------------------------------------------
// MARK: - Get random symbol from string
//-----------------------------------------------------------------------------

public extension String {
    /// Returns random symbol from string
    public func randomSymbol() -> String {
        let count: UInt32 = UInt32(characters.count)
        let random: Int = Int(arc4random_uniform(count))
        return self[random]
    }
}

//-----------------------------------------------------------------------------
// MARK: - Trimming
//-----------------------------------------------------------------------------

public extension String {
    /// Strips whitespace and new line characters
    public var trimmed: String {
        let trimmedString = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }
}

//-----------------------------------------------------------------------------
// MARK: - Appending
//-----------------------------------------------------------------------------

public extension String {
    public mutating func appendNewLine() {
        append("\n")
    }
    
    public mutating func append(valueName: String?, value: Any?, separator: String = ", ") {
        var stringRepresentation: String
        if let value = g_unwrap(value) {
            if let value = value as? String {
                stringRepresentation = value
            } else if let bool = value as? Bool {
                stringRepresentation = bool ? "true" : "false"
            } else {
                stringRepresentation = String(describing: value)
            }
        } else {
            stringRepresentation = "nil"
        }
        
        if let valueName = valueName {
            append(string: "\(valueName):", separator: separator)
            appendWithSpace(stringRepresentation)
        } else {
            append(string: stringRepresentation, separator: separator)
        }
    }
    
    public mutating func appendWithNewLine(_ string: String?) {
        append(string: string, separator: "\n")
    }
    
    public mutating func appendWithSpace(_ string: String?) {
        append(string: string, separator: " ")
    }
    
    public mutating func appendWithComma(_ string: String?) {
        append(string: string, separator: ", ")
    }
    
    public mutating func append(string: String?, separator: String) {
        guard let string = string, !string.isEmpty else { return }
        
        if isEmpty {
            self.append(string)
        } else {
            self.append("\(separator)\(string)")
        }
    }
    
    public mutating func wrap(`class`: Any.Type) {
        self = String(format: "%@(%@)", String(describing: `class`), self)
    }
}

//-----------------------------------------------------------------------------
// MARK: - Splitting
//-----------------------------------------------------------------------------

public extension String {
    /// Splits string by capital letters without stripping them
    public var splittedByCapitals: [String] {
        return characters.splitBefore(separator: { $0.isUpperCase }).map({ String($0) })
    }
    
    /// Split string into slices of specified length
    public func splitByLength(_ length: Int) -> [String] {
        var result = [String]()
        var collectedCharacters = [Character]()
        collectedCharacters.reserveCapacity(length)
        var count = 0
        
        for character in self.characters {
            collectedCharacters.append(character)
            count += 1
            if (count == length) {
                // Reached the desired length
                count = 0
                result.append(String(collectedCharacters))
                collectedCharacters.removeAll(keepingCapacity: true)
            }
        }
        
        // Append the remainder
        if !collectedCharacters.isEmpty {
            result.append(String(collectedCharacters))
        }
        
        return result
    }
}

//-----------------------------------------------------------------------------
// MARK: - Bounding Rect
//-----------------------------------------------------------------------------

public extension String {
    /// Width of a string written in one line.
    public func oneLineWidth(font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.width
    }
    
    /// Height of a string for specified font and width.
    public func height(font: UIFont, width: CGFloat) -> CGFloat {
        return height(attributes: [NSAttributedStringKey.font: font], width: width)
    }
    
    /// Height of a string for specified attributes and width.
    public func height(attributes: [NSAttributedStringKey: Any], width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let height = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).height.rounded(.up)
        
        return height
    }
}
