//
//  UITextField+ViewConfiguration.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 10/4/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension UITextField {
    public enum TextFieldState {
        case hidden
        case shown(text: String?, placeholder: String?)
        case transparent
        
        public var text: String? {
            switch self {
            case .hidden, .transparent: return nil
            case .shown(let text, _): return text
            }
        }
        
        public var placeholder: String? {
            switch self {
            case .hidden, .transparent: return nil
            case .shown(_, let placeholder): return placeholder
            }
        }
    }
    
    public func configure(textFieldState: TextFieldState) {
        switch textFieldState {
        case .hidden:
            isHidden = true
            
        case .shown(let _text, let _placeholder):
            text = _text
            placeholder = _placeholder
            isHidden = false
            alpha = 1
            
        case .transparent:
            isHidden = false
            alpha = 0
        }
    }
}
