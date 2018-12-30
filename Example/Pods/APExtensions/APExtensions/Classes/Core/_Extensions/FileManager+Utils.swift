//
//  FileManager+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 12/12/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


public extension FileManager {
    /// Checks if FILE exists at URL
    @available(iOS 9.0, *)
    public func fileExists(at url: URL) -> Bool {
        guard url.isFileURL && !url.hasDirectoryPath else { return false }
        
        var isDirectory: ObjCBool = ObjCBool(false)
        let itemExists = self.fileExists(atPath: url.path, isDirectory: &isDirectory)
        
        return itemExists && !isDirectory.boolValue
    }
    
    /// Checks if directory exists at URL
    @available(iOS 9.0, *)
    public func directoryExists(at url: URL) -> Bool {
        guard url.isFileURL && url.hasDirectoryPath else { return false }
        
        var isDirectory: ObjCBool = ObjCBool(false)
        let itemExists = self.fileExists(atPath: url.path, isDirectory: &isDirectory)
        
        return itemExists && isDirectory.boolValue
    }
    
    @available(iOS 9.0, *)
    public func itemExists(at url: URL) -> Bool {
        let isItemDirectory = url.hasDirectoryPath
        
        var isDirectory: ObjCBool = ObjCBool(false)
        let itemExists = self.fileExists(atPath: url.path, isDirectory: &isDirectory)
        
        if isItemDirectory {
            return isDirectory.boolValue && itemExists
        } else {
            return !isDirectory.boolValue && itemExists
        }
    }
}
