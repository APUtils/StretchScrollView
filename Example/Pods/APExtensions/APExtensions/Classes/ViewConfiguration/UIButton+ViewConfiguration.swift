//
//  UIButton+ViewConfiguration.swift
//  Pods
//
//  Created by Anton Plebanovich on 10/4/17.
//  
//

import UIKit


public extension UIButton {
    public enum ButtonState {
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
    
    public func configure(buttonState: ButtonState) {
        switch buttonState {
        case .hidden:
            isHidden = true
            
        case .shown(let text):
            setTitle(text, for: .normal)
            isHidden = false
            alpha = 1
            
        case .transparent:
            isHidden = false
            alpha = 0
        }
    }
}
