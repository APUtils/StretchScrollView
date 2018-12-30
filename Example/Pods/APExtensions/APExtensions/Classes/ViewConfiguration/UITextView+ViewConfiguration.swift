//
//  UITextView+ViewConfiguration.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 10/4/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension UITextView {
    public enum TextViewState {
        case hidden
        case shown(text: String?)
        case transparent
        
        public var text: String? {
            switch self {
            case .hidden, .transparent: return nil
            case .shown(let text): return text
            }
        }
    }
    
    public func configure(textViewState: TextViewState) {
        switch textViewState {
        case .hidden:
            isHidden = true
            
        case .shown(let _text):
            text = _text
            isHidden = false
            alpha = 1
            
        case .transparent:
            isHidden = false
            alpha = 0
        }
    }
}
