//
//  UIImageView+ViewConfiguration.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 9/11/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension UIImageView {
    public enum ImageViewState {
        case hidden
        case shown(image: UIImage?)
        case transparent
        
        public var image: UIImage? {
            switch self {
            case .hidden, .transparent: return nil
            case .shown(let image): return image
            }
        }
    }
    
    public func configure(imageViewState: ImageViewState) {
        switch imageViewState {
        case .hidden:
            isHidden = true
            
        case .shown(let _image):
            image = _image
            isHidden = false
            alpha = 1
            
        case .transparent:
            isHidden = false
            alpha = 0
        }
    }
}
