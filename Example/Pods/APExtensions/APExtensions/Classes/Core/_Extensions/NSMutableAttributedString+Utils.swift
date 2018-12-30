//
//  NSMutableAttributedString+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 1/18/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension NSMutableAttributedString {
    /// Sets font for the first occurence of text. If text is `nil` sets font for entire string.
    public func set(font: UIFont, for text: String? = nil) {
        let range: NSRange
        if let text = text {
            range = mutableString.range(of: text)
        } else {
            range = fullRange
        }
        
        guard range.location != NSNotFound else { return }
        
        addAttribute(.font, value: font, range: range)
    }
    
    /// Sets aligment for the first occurence of text. If text is `nil` sets aligment for entire string.
    public func set(font: UIFont? = nil,
             aligment: NSTextAlignment? = nil,
             headIndent: CGFloat? = nil,
             lineSpacing: CGFloat? = nil,
             lineHeightMultiple: CGFloat? = nil,
             for text: String? = nil) {
        
        let range: NSRange
        if let text = text {
            range = mutableString.range(of: text)
        } else {
            range = fullRange
        }
        
        guard range.location != NSNotFound else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        if let aligment = aligment { paragraphStyle.alignment = aligment }
        if let headIndent = headIndent { paragraphStyle.headIndent = headIndent }
        if let lineSpacing = lineSpacing { paragraphStyle.lineSpacing = lineSpacing }
        if let lineHeightMultiple = lineHeightMultiple { paragraphStyle.lineHeightMultiple = lineHeightMultiple }
        
        addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
    }
    
    /// Set text kern
    public func set(kern: CGFloat) {
        addAttribute(.kern, value: kern, range: fullRange)
    }
    
    /// Makes text underlined
    public func setUnderline() {
        addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: fullRange)
    }
}
