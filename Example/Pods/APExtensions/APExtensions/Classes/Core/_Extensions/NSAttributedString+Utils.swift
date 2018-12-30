//
//  NSAttributedString+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 9/21/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


public extension NSAttributedString {
    /// Range from the start to the end.
    public var fullRange: NSRange {
        return NSRange(location: 0, length: length)
    }
    
    /// Height of a string for specified width.
    public func height(width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let height = boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).height.rounded(.up)
        
        return height
    }
}
