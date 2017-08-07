//
//  UINavigationBar+StretchScrollView.swift
//  StretchScrollView
//
//  Created by Anton Plebanovich on 8/7/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


private var transparencyStateAssociationKey = 0


extension UINavigationBar {
    struct TransparencyState {
        let isTranslucent: Bool
        let backgroundImage: UIImage?
        let shadowImage: UIImage?
    }
    
    private var transparencyState: TransparencyState? {
        get {
            return objc_getAssociatedObject(self, &transparencyStateAssociationKey) as? TransparencyState
        }
        set {
            objc_setAssociatedObject(self, &transparencyStateAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func saveTransparencyState(replace: Bool) {
        guard replace || transparencyState == nil else { return }
        
        transparencyState = TransparencyState(isTranslucent: isTranslucent, backgroundImage: backgroundImage(for: .default), shadowImage: shadowImage)
    }
    
    func restoreTransparencyState() {
        guard let transparencyState = transparencyState else { return }
        
        isTranslucent = transparencyState.isTranslucent
        setBackgroundImage(transparencyState.backgroundImage, for: .default)
        shadowImage = transparencyState.shadowImage
    }
    
    func makeTransparent() {
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }
}
