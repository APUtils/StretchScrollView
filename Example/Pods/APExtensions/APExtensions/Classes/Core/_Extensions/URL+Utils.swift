//
//  URL+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 11/1/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


public extension URL {
    /// File name without extension. Nil if it's directory.
    @available(iOS 9.0, *)
    public var fileName: String? {
        guard !hasDirectoryPath else { return nil }
        
        return String(lastPathComponent.split(separator: ".")[0])
    }
    
    /// Check if it's URL to local directory
    @available(iOS 9.0, *)
    public var isLocalDirectory: Bool {
        return isFileURL && hasDirectoryPath
    }
    
    /// Check if it's URL to local file
    @available(iOS 9.0, *)
    public var isLocalFile: Bool {
        return isFileURL && !hasDirectoryPath
    }
    
    /// Try to init UIImage from URL to check if this URL points to an image.
    @available(iOS 9.0, *)
    public var isImageUrl: Bool {
        guard isFileURL && !hasDirectoryPath else { return false }
        
        return UIImage(contentsOfFile: path) != nil
    }
    
    /// Appends path component and prevents double slashes if URL has trailing slash and path component has leading slash.
    public func smartAppendingPathComponent(_ pathComponent: String, isDirectory: Bool = false) -> URL {
        guard !pathComponent.isEmpty else { return self }
        
        var pathComponent = pathComponent
        if pathComponent[0] == "/" {
            pathComponent = String(pathComponent.dropFirst())
        }
        
        return appendingPathComponent(pathComponent, isDirectory: isDirectory)
    }
}
