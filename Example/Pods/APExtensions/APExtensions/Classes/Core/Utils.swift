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

/// Closure that takes Void and returns Void.
public typealias SimpleClosure = () -> ()

/// Closure that takes Bool and returns Void.
public typealias SuccessClosure = (_ success: Bool) -> ()

//-----------------------------------------------------------------------------
// MARK: - Global Structs
//-----------------------------------------------------------------------------

/// Structure containing screen sizes. Available constants: `width`, `height`, `maxSide`, `minSide`
public struct g_screenSize {
    @nonobjc public static let width = UIScreen.main.bounds.size.width
    @nonobjc public static let height = UIScreen.main.bounds.size.height
    @nonobjc public static let maxSide = max(g_screenSize.width, g_screenSize.height)
    @nonobjc public static let minSide = min(g_screenSize.width, g_screenSize.height)
}

//-----------------------------------------------------------------------------
// MARK: - Comparison
//-----------------------------------------------------------------------------

/// Compares two `CGSize`s with 0.0001 tolerance
public func g_isCGSizesEqual(first: CGSize, second: CGSize) -> Bool {
    if abs(first.width - second.width) < 0.0001 && abs(first.height - second.height) < 0.0001 {
        return true
    } else {
        return false
    }
}

/// Compares two `CGFloat`s with 0.0001 tolerance
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

/// Shared application
public let g_sharedApplication = UIApplication.shared

/// Standart user defaults
public let g_sharedUserDefaults = UserDefaults.standard

/// Default notification center
public let g_sharedNotificationCenter = NotificationCenter.default

/// Is running on simulator?
public let g_isSimulator = TARGET_OS_SIMULATOR != 0

/// Screen pixel size
public let g_pixelSize: CGFloat = 1 / UIScreen.main.scale

/// User documents directory URL
public var g_documentsDirectoryUrl: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

/// User cache directory URL
public var g_cacheDirectoryUrl: URL {
    return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
}

/// Application delegate
public var g_appDelegate: UIApplicationDelegate {
    return g_sharedApplication.delegate!
}

/// Application key window
public var g_keyWindow: UIWindow? {
    return g_sharedApplication.keyWindow
}

/// Application root view controller
public var g_rootViewController: UIViewController {
    return g_appDelegate.window!!.rootViewController!
}

/// Is application in `active` state?
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

/// Returns top most view controller that handles status bar style.
/// This property might be more accurate than `g_topViewController` if custom container view controllers configured properly to return their top most controllers for status bar appearance.
public var g_statusBarStyleTopViewController: UIViewController? {
    var currentVc = g_appDelegate.window??.rootViewController
    while let newTopVc = currentVc?.childViewControllerForStatusBarStyle {
        currentVc = newTopVc
    }
    
    return currentVc
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
public func g_showErrorAlert(title: String? = nil, message: String? = nil, actionTitle: String = "Dismiss", isDestructAction: Bool = false, cancelTitle: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
    let alertVC = AlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alertVC.addAction(UIAlertAction(title: actionTitle, style: isDestructAction ? .destructive : .default, handler: handler))
    if let cancelTitle = cancelTitle {
        alertVC.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.default, handler: nil))
    }
    
    alertVC.present(animated: true)
}

/// Shows enter text alert with title and message
/// - parameter title: Alert title
/// - parameter message: Alert message
/// - parameter completion: Closure that takes user entered text as parameter
public func g_showEnterTextAlert(title: String? = nil, message: String? = nil, completion: @escaping (_ text: String) -> ()) {
    let alertVC = AlertController(title: title, message: message, preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "Confirm", style: .cancel) { action in
        let text = alertVC.textFields?.first?.text ?? ""
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

/// Shows picker alert with title and message.
/// - parameter title: Alert title
/// - parameter buttons: Button titles
/// - parameter buttonsStyles: Button styles
/// - parameter enabledButtons: Enabled buttons
/// - parameter completion: Closure that takes button title and button index as its parameters
public func g_showPickerAlert(title: String? = nil, message: String? = nil, buttons: [String], buttonsStyles: [UIAlertActionStyle]? = nil, enabledButtons: [Bool]? = nil, completion: @escaping ((String, Int) -> ())) {
    if let buttonsStyles = buttonsStyles, buttons.count != buttonsStyles.count { print("Invalid buttonsStyles count"); return }
    if let enabledButtons = enabledButtons, buttons.count != enabledButtons.count { print("Invalid enabledButtons count"); return }
    
    let vc = AlertController(title: title, message: message, preferredStyle: .actionSheet)
    
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    vc.addAction(cancel)
    
    for (index, button) in buttons.enumerated() {
        let buttonStyle = buttonsStyles?[index] ?? .default
        let action = UIAlertAction(title: button, style: buttonStyle, handler: { _ in
            completion(button, index)
        })
        
        if let enabledButtons = enabledButtons, enabledButtons.count == buttons.count {
            action.isEnabled = enabledButtons[index]
        }
        
        vc.addAction(action)
    }
    
    vc.present(animated: true)
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

/// Takes 0.003s - 0.02s on 5s device. Example usage:
///
///     let setupOnes: [SetupOnce.Type] = g_getClassesConformToProtocol(SetupOnce.self)
public func g_getClassesConformToProtocol<T>(_ protocol: Protocol) -> [T] {
    return APExtensionsLoader.getClassesConform(to: `protocol`).flatMap({ $0 as? T })
}

public func g_Translate(_ string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
