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

/// Helps to instantiate object from xib file.
public protocol InstantiatableFromXib {
    static func create() -> Self
}

public extension InstantiatableFromXib where Self: NSObject {
    private static func objectFromXib<T>() -> T {
        return UINib(nibName: className, bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
    }
    
    /// Instantiates object from xib file. 
    /// Xib filename should be equal to object class name.
    public static func create() -> Self {
        return objectFromXib()
    }
}

//-----------------------------------------------------------------------------
// MARK: - InstantiatableFromStoryboard
//-----------------------------------------------------------------------------

/// Helps to instantiate object from storyboard file.
public protocol InstantiatableFromStoryboard: class {
    static func create() -> Self
    static func createWithNavigationController() -> UINavigationController
}

public extension InstantiatableFromStoryboard where Self: UIViewController {
    private static func controllerFromStoryboard<T>() -> T {
        let storyboardName = className.replacingOccurrences(of: "ViewController", with: "")
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController() as! T
    }
    
    /// Instantiates view controller from storyboard file.
    /// Storyboard filename should be equal to view controller class name without "ViewControler" postfix.
    public static func create() -> Self {
        return controllerFromStoryboard()
    }
    
    /// Instantiates view controller from storyboard file wrapped into navigation controller.
    /// Storyboard filename should be equal to view controller class name without "ViewControler" postfix.
    public static func createWithNavigationController() -> UINavigationController {
        let vc = create()
        let navigationVc = UINavigationController(rootViewController: vc)
        
        return navigationVc
    }
}

//-----------------------------------------------------------------------------
// MARK: - InstantiatableContentView
//-----------------------------------------------------------------------------

/// Helps to instantiate content view from storyboard file.
public protocol InstantiatableContentView {
    func createContentView() -> UIView
}

public extension InstantiatableContentView where Self: NSObject {
    /// Instantiates contentView from xib file and making instantiator it's owner.
    /// Xib filename should be composed of className + "ContentView" postfix. E.g. MyView -> MyViewContentView
    public func createContentView() -> UIView {
        return UINib(nibName: "\(type(of: self).className)ContentView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
