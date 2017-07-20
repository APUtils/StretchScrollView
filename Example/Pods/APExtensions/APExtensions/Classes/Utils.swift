//
//  Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 07/10/2017.
//  Copyright (c) 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

// TODO: Add description for functions

//-----------------------------------------------------------------------------
// MARK: - Typealiases
//-----------------------------------------------------------------------------

public typealias SimpleClosure = () -> ()

//-----------------------------------------------------------------------------
// MARK: - Global Structs
//-----------------------------------------------------------------------------

public struct g_screenSize {
    @nonobjc static let width = UIScreen.main.bounds.size.width
    @nonobjc static let height = UIScreen.main.bounds.size.height
    @nonobjc static let maxSide = max(g_screenSize.width, g_screenSize.height)
    @nonobjc static let minSide = min(g_screenSize.width, g_screenSize.height)
}

//-----------------------------------------------------------------------------
// MARK: - Comparison
//-----------------------------------------------------------------------------

public func g_isCGSizeEqual(first: CGSize, second: CGSize) -> Bool {
    if abs(first.width - second.width) < 0.0001 && abs(first.height - second.height) < 0.0001 {
        return true
    } else {
        return false
    }
}

public func g_isCGFloatsEqual(first: CGFloat, second: CGFloat) -> Bool {
    if abs(first - second) < 0.0001 {
        return true
    } else {
        return false
    }
}

//-----------------------------------------------------------------------------
// MARK: - Global Vars
//-----------------------------------------------------------------------------

public let g_sharedApplication = UIApplication.shared
public let g_sharedUserDefaults = UserDefaults.standard
public let g_sharedNotificationCenter = NotificationCenter.default
public let g_isSimulator = TARGET_OS_SIMULATOR != 0
public let g_pixelSize: CGFloat = 1 / UIScreen.main.scale

public var g_documentsDirectoryUrl: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

public var g_cacheDirectoryUrl: URL {
    return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
}

public var g_appDelegate: UIApplicationDelegate {
    return g_sharedApplication.delegate!
}

public var g_keyWindow: UIWindow? {
    return g_sharedApplication.keyWindow
}

public var g_rootViewController: UIViewController {
    return g_appDelegate.window!!.rootViewController!
}

public var g_isActive: Bool {
    return g_sharedApplication.applicationState == .active
}

//-----------------------------------------------------------------------------
// MARK: - Unwrap
//-----------------------------------------------------------------------------

/// Helper protocol
private protocol _Optional {
    var value: Any? { get }
}

extension Optional: _Optional {
    var value: Any? {
        switch self {
        case .none: return nil
        case .some(_): return self!
        }
    }
}

/// Removes nested optionals until only one left
public func g_unwrap(_ _any: Any?) -> Any? {
    guard let any = _any else { return _any }
    
    // Check if Any actually is Any?
    if let optionalAny = any as? _Optional {
        return g_unwrap(optionalAny.value)
    } else {
        return any
    }
}

//-----------------------------------------------------------------------------
// MARK: - Top Controller
//-----------------------------------------------------------------------------

/// Current top most view controller
public var g_topViewController: UIViewController? {
    return g_topViewController()
}

public func g_topViewController(base: UIViewController? = g_appDelegate.window??.rootViewController, isCheckPresented: Bool = true) -> UIViewController? {
    if let navigationVc = base as? UINavigationController {
        return g_topViewController(base: navigationVc.topViewController, isCheckPresented: isCheckPresented)
    }
    
    if let tabBarVc = base as? UITabBarController {
        if let selected = tabBarVc.selectedViewController {
            return g_topViewController(base: selected, isCheckPresented: isCheckPresented)
        }
    }
    
    if isCheckPresented, let presented = base?.presentedViewController {
        return g_topViewController(base: presented, isCheckPresented: isCheckPresented)
    }
    
    return base
}

//-----------------------------------------------------------------------------
// MARK: - Animations
//-----------------------------------------------------------------------------

public func g_animate(animations: @escaping SimpleClosure) {
    g_animate(animations: animations, completion: nil)
}

public func g_animate(_ duration: Double, animations: @escaping SimpleClosure) {
    g_animate(duration, animations: animations, completion: nil)
}

public func g_animate(_ duration: Double, options: UIViewAnimationOptions, animations: @escaping SimpleClosure) {
    g_animate(duration, options: options, animations: animations, completion: nil)
}

public func g_animate(_ duration: Double = 0.3, delay: Double = 0, options: UIViewAnimationOptions = .beginFromCurrentState, animations: @escaping SimpleClosure, completion: ((Bool) -> ())? = nil) {
    UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: completion)
}

//-----------------------------------------------------------------------------
// MARK: - Dispatch
//-----------------------------------------------------------------------------

/// Executes a closure in a default queue after requested seconds. Uses GCD.
/// - parameters:
///   - delay: number of seconds to delay
///   - closure: the closure to be executed
public func g_asyncBg(_ delay: Double = 0, closure: @escaping SimpleClosure) {
    let delayTime: DispatchTime = .now() + delay
    DispatchQueue.global(qos: .default).asyncAfter(deadline: delayTime, execute: {
        closure()
    })
}

/// Executes a closure if already in background or dispatch asyn in background. Uses GCD.
/// - parameters:
///   - closure: the closure to be executed
public func g_performInBackground(_ closure: @escaping SimpleClosure) {
    if Thread.isMainThread {
        DispatchQueue.global(qos: .default).async {
            closure()
        }
    } else {
        closure()
    }
}

/// Executes a closure in the main queue after requested seconds asynchronously. Uses GCD.
/// - parameters:
///   - delay: number of seconds to delay
///   - closure: the closure to be executed
public func g_asyncMain(_ delay: Double = 0, closure: @escaping SimpleClosure) {
    let delayTime: DispatchTime = .now() + delay
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        closure()
    }
}

/// Executes a closure if already in main or dispatch asyn in main. Uses GCD.
/// - parameters:
///   - closure: the closure to be executed
public func g_performInMain(_ closure: @escaping SimpleClosure) {
    if !Thread.isMainThread {
        DispatchQueue.main.async {
            closure()
        }
    } else {
        closure()
    }
}

//-----------------------------------------------------------------------------
// MARK: - Alerts
//-----------------------------------------------------------------------------

/// Shows error alert with title, message, action title, cancel title and handler
/// - parameter title: Alert title
/// - parameter message: Alert message
/// - parameter actionTitle: Action button title
/// - parameter isDestructAction: Is action button destructive style or no
/// - parameter cancelTitle: Cancel button title
/// - parameter handler: Action button click closure
public func g_showErrorAlert(
    title: String? = nil,
    message: String? = nil,
    actionTitle: String = "Dismiss",
    isDestructAction: Bool = false,
    cancelTitle: String? = nil,
    handler: ((UIAlertAction) -> Void)? = nil) {
    
    let alertVC = AlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alertVC.addAction(UIAlertAction(title: actionTitle, style: isDestructAction ? .destructive : .default, handler: handler))
    if let cancelTitle = cancelTitle {
        alertVC.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.default, handler: nil))
    }
    
    alertVC.present(animated: true)
}

public func g_showEnterTextAlert(title: String?, message: String?, completion: @escaping (_ text: String?) -> ()) {
    let alertVC = AlertController(title: title, message: message, preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "Confirm", style: .cancel) { action in
        let text = alertVC.textFields![0].text
        completion(text)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    
    alertVC.addTextField { (textField) in
        textField.placeholder = "List name"
    }
    
    alertVC.addAction(confirmAction)
    alertVC.addAction(cancelAction)
    
    alertVC.present(animated: true)
}

//-----------------------------------------------------------------------------
// MARK: - Network Activity
//-----------------------------------------------------------------------------

private var networkActivityCounter = 0

public func g_showNetworkActivity() {
    networkActivityCounter = max(0, networkActivityCounter)
    networkActivityCounter += 1
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
}

public func g_hideNetworkActivity() {
    networkActivityCounter -= 1
    
    if networkActivityCounter <= 0 {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

//-----------------------------------------------------------------------------
// MARK: - Swizzle
//-----------------------------------------------------------------------------

public func g_swizzleClassMethods(class: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
    guard class_isMetaClass(`class`) else { return }
    
    let originalMethod = class_getClassMethod(`class`, originalSelector)!
    let swizzledMethod = class_getClassMethod(`class`, swizzledSelector)!
    
    swizzleMethods(class: `class`, originalSelector: originalSelector, originalMethod: originalMethod, swizzledSelector: swizzledSelector, swizzledMethod: swizzledMethod)
}

public func g_swizzleMethods(class: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
    guard !class_isMetaClass(`class`) else { return }
    
    let originalMethod = class_getInstanceMethod(`class`, originalSelector)!
    let swizzledMethod = class_getInstanceMethod(`class`, swizzledSelector)!
    
    swizzleMethods(class: `class`, originalSelector: originalSelector, originalMethod: originalMethod, swizzledSelector: swizzledSelector, swizzledMethod: swizzledMethod)
}

private func swizzleMethods(class: AnyClass, originalSelector: Selector, originalMethod: Method, swizzledSelector: Selector, swizzledMethod: Method) {
    let didAddMethod = class_addMethod(`class`, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
    
    if didAddMethod {
        class_replaceMethod(`class`, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

//-----------------------------------------------------------------------------
// MARK: - Other Global Functions
//-----------------------------------------------------------------------------

public func g_Translate(_ string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
