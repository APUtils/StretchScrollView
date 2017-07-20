//
//  Instantiatable.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 6/19/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

//-----------------------------------------------------------------------------
// MARK: - InstantiatableFromXib
//-----------------------------------------------------------------------------

public protocol InstantiatableFromXib {
    static func create() -> Self
}

public extension InstantiatableFromXib where Self: NSObject {
    private final static func objectFromXib<T>() -> T {
        return UINib(nibName: className, bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
    }
    
    /// Instantiates object from xib file. 
    /// Xib filename should be equal to object class name.
    public final static func create() -> Self {
        return objectFromXib()
    }
}

//-----------------------------------------------------------------------------
// MARK: - InstantiatableFromStoryboard
//-----------------------------------------------------------------------------

public protocol InstantiatableFromStoryboard: class {
    static func create() -> Self
    static func createWithNavigationController() -> UINavigationController
}

public extension InstantiatableFromStoryboard where Self: UIViewController {
    private final static func controllerFromStoryboard<T>() -> T {
        let storyboardName = className.replacingOccurrences(of: "ViewController", with: "")
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController() as! T
    }
    
    public final static func create() -> Self {
        return controllerFromStoryboard()
    }
    
    public final static func createWithNavigationController() -> UINavigationController {
        let vc = create()
        let navigationVc = UINavigationController(rootViewController: vc)
        
        return navigationVc
    }
}

//-----------------------------------------------------------------------------
// MARK: - InstantiatableContentView
//-----------------------------------------------------------------------------

public protocol InstantiatableContentView {
    func createContentView() -> UIView
}

public extension InstantiatableContentView where Self: NSObject {
    /// Instantiates contentView from xib file and making instantiator it's owner.
    /// Xib filename should be composed of className + "ContentView" postfix. E.g. MyView -> MyViewContentView
    public final func createContentView() -> UIView {
        return UINib(nibName: "\(type(of: self).className)ContentView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
