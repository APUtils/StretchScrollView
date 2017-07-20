//
//  Debug.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 7/4/17.
//  Copyright © Anton Plebanovich. All rights reserved.
//

import Foundation

//-----------------------------------------------------------------------------
// MARK: - Debug logs
//-----------------------------------------------------------------------------

private let timeFormatter: DateFormatter = {
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:mm:ss.SSS"
    
    return timeFormatter
}()


public func Log(_ object: Any?, _ file: String = #file, _ function: String = #function, _ line: Int = #line, showDelimiter: Bool = true) {
    #if DEBUG
        let stringRepresentation: String
        if let value = object {
            stringRepresentation = String(describing: value)
        } else {
            stringRepresentation = "nil"
        }
        
        let time = timeFormatter.string(from: Date())
        let fileURL = NSURL(fileURLWithPath: file).lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "UI" : "BG"
        
        let delimiter = "******************************************************"
        let logString = "\(time): <\(queue)> \(fileURL) - [\(line)] - \(function)\n\n\(stringRepresentation)"
        if showDelimiter {
            print()
            print(delimiter)
            print(logString)
            print(delimiter)
            print()
        } else {
            print(logString)
        }
    #endif
}

public func smartPrint(_ object: Any?, addNewLines: Bool = true, useDebugPrint: Bool = false) {
    #if DEBUG
        if let value = g_unwrap(object) {
            if let values = value as? [Any] {
                print("\n")
                for (i, value) in values.enumerated() {
                    print("[ \(i) ]:")
                    smartPrint(value, addNewLines: false)
                    print()
                }
                print()
            } else if let dictionary = value as? [String: Any] {
                print("\n")
                for (key, value) in dictionary {
                    print("[ \(key) ]:")
                    smartPrint(value, addNewLines: false)
                    print()
                }
                print()
            } else {
                let string = useDebugPrint ? String(reflecting: value) : String(describing: value)
                if addNewLines {
                    print()
                    print(string)
                    print()
                } else {
                    print(string)
                }
            }
        } else {
            let string = "\nnil\n"
            if addNewLines {
                print()
                print(string)
                print()
            } else {
                print(string)
            }
        }
    #endif
}
