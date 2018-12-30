//
//  Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 07/10/2017.
//  Copyright (c) 2017 Anton Plebanovich. All rights reserved.
//

import UIKit
import MessageUI

// TODO: Add description for functions

// ******************************* MARK: - Typealiases

/// Closure that takes Void and returns Void.
public typealias SimpleClosure = () -> Void

/// Closure that takes Bool and returns Void.
public typealias SuccessClosure = (_ success: Bool) -> Void

/// Closure that takes Bool and returns Void.
public typealias ErrorClosure = (_ error: Error?) -> Void

// ******************************* MARK: - Error

/// Error stub to use for simplification
public struct GeneralError: Error { public init() {} }

// ******************************* MARK: - Comparison

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

// ******************************* MARK: - Global Vars

/// Shared application
public let g_sharedApplication = UIApplication.shared

/// Default file manager
public var g_sharedFileManager: FileManager {
    return FileManager.default
}

/// Default notification center
public var g_sharedNotificationCenter: NotificationCenter {
    return NotificationCenter.default
}

/// Shared user defaults
public var g_sharedUserDefaults: UserDefaults {
    return UserDefaults.standard
}

/// Is running on simulator?
public let g_isSimulator = TARGET_OS_SIMULATOR != 0

/// Screen size
public let g_screenSize = UIScreen.main.bounds.size

/// Screen scale factor
public var g_screenScale: CGFloat {
    return UIScreen.main.scale
}

/// Screen pixel size
public var g_pixelSize: CGFloat {
    return 1 / UIScreen.main.scale
}

/// User documents directory URL
public var g_documentsDirectoryUrl: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

/// User temporary directory URL
public var g_tempDirectoryUrl: URL {
    return URL(fileURLWithPath: NSTemporaryDirectory())
}

/// User cache directory URL
public var g_cacheDirectoryUrl: URL {
    return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
}

/// Application delegate. Crashes if nil.
public let g_appDelegate: UIApplicationDelegate = g_sharedApplication.delegate!

/// Application key window
public var g_keyWindow: UIWindow? {
    return g_sharedApplication.keyWindow
}

/// Application window. Crashes if nil.
var g_appWindow: UIWindow {
    return g_appDelegate.window!!
}

/// Application root view controller. Crashes if nil.
public var g_rootViewController: UIViewController {
    return g_appDelegate.window!!.rootViewController!
}

/// Is application in `active` state?
public var g_isAppActive: Bool {
    return g_sharedApplication.applicationState == .active
}

/// Detect if the app is running unit tests.
/// Note this only detects unit tests, not UI tests.
public var g_isRunningUnitTests: Bool {
    return ProcessInfo.processInfo.environment.keys.contains("XCTestConfigurationFilePath")
}

// ******************************* MARK: - Swift Exception Handling

public func g_perform(_ closure: SimpleClosure) -> NSException? {
    return APUtils.perform(closure)
}

// ******************************* MARK: - Unwrap

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

// ******************************* MARK: - Top Controller

/// Current top most view controller
public var g_topViewController: UIViewController? {
    return g_topViewController()
}

/// Returns top view controller from `base` controller.
/// - note: In case you are using custom container controllers in your application this method won't be able to process them.
/// - parameters:
///   - base: Base controller from which to start. If not specified or nil then application delegate window's rootViewController will be used.
///   - shouldCheckPresented: Should it check for presented controllers?
public func g_topViewController(base: UIViewController? = nil, shouldCheckPresented: Bool = true) -> UIViewController? {
    let base = base ?? g_appDelegate.window??.rootViewController
    
    if let navigationVc = base as? UINavigationController {
        return g_topViewController(base: navigationVc.topViewController, shouldCheckPresented: shouldCheckPresented)
    }
    
    if let tabBarVc = base as? UITabBarController {
        if let selected = tabBarVc.selectedViewController {
            return g_topViewController(base: selected, shouldCheckPresented: shouldCheckPresented)
        }
    }
    
    if shouldCheckPresented, let presented = base?.presentedViewController {
        return g_topViewController(base: presented, shouldCheckPresented: shouldCheckPresented)
    }
    
    return base
}

/// Returns top most view controller that handles status bar style.
/// This property might be more accurate than `g_topViewController` if custom container view controllers configured properly to return their top most controllers for status bar appearance.
public var g_statusBarStyleTopViewController: UIViewController? {
    var currentVc = g_topViewController
    while let newTopVc = currentVc?.childForStatusBarStyle {
        currentVc = g_topViewController(base: newTopVc)
    }
    
    return currentVc
}

// ******************************* MARK: - Animations

public func g_animate(animations: @escaping SimpleClosure) {
    g_animate(animations: animations, completion: nil)
}

public func g_animate(_ duration: TimeInterval, animations: @escaping SimpleClosure) {
    g_animate(duration, animations: animations, completion: nil)
}

public func g_animate(_ duration: TimeInterval, options: UIView.AnimationOptions, animations: @escaping SimpleClosure) {
    g_animate(duration, options: options, animations: animations, completion: nil)
}

public func g_animate(_ duration: TimeInterval = 0.3, delay: TimeInterval = 0, options: UIView.AnimationOptions = .beginFromCurrentState, animations: @escaping SimpleClosure, completion: ((Bool) -> ())? = nil) {
    UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: completion)
}

// ******************************* MARK: - Dispatch

/// Executes a closure in a default queue after requested seconds. Uses GCD.
/// - parameters:
///   - delay: number of seconds to delay
///   - closure: the closure to be executed
public func g_asyncBg(_ delay: TimeInterval = 0, closure: @escaping SimpleClosure) {
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
public func g_asyncMain(_ delay: TimeInterval = 0, closure: @escaping SimpleClosure) {
    let delayTime: DispatchTime = .now() + delay
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        closure()
    }
}

/// Executes a closure if already in main or dispatch asyn in main. Uses GCD.
/// - parameters:
///   - closure: the closure to be executed
public func g_performInMain(_ closure: @escaping SimpleClosure) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async { closure() }
    }
}

// ******************************* MARK: - Thread Safety

/// Helper function that mimics objc @synchronized(self) {...} behaviour and syntax
public func g_synchronized(_ lock: Any, closure: () throws -> Void) rethrows {
    objc_sync_enter(lock); defer { objc_sync_exit(lock) }
    
    try closure()
}

// ******************************* MARK: - Alerts

/// Shows error alert with title, message, action title, cancel title and handler
/// - parameter title: Alert title. Default is `nil` - no title.
/// - parameter message: Alert message. Default is `nil` - no message.
/// - parameter actionTitle: Action button title. Default is `Dismiss`.
/// - parameter style: Action button style. Default is `.cancel`.
/// - parameter cancelTitle: Cancel button title. Default is `nil` - no cancel button.
/// - parameter handler: Action button click closure. Default is `nil` - no action.
public func g_showErrorAlert(title: String? = nil, message: String? = nil, actionTitle: String = "Dismiss", style: UIAlertAction.Style = .cancel, cancelTitle: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
    let alertVC = AlertController(title: title, message: message, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: actionTitle, style: style, handler: handler))
    if let cancelTitle = cancelTitle {
        alertVC.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: nil))
    }
    
    alertVC.present(animated: true)
}

/// Shows enter text alert with title and message
/// - parameter title: Alert title
/// - parameter message: Alert message
/// - parameter placeholder: Text field placeholder
/// - parameter completion: Closure that takes user entered text as parameter
public func g_showEnterTextAlert(title: String? = nil, message: String? = nil, text: String? = nil, placeholder: String? = nil, completion: @escaping (_ text: String) -> ()) {
    let alertVC = AlertController(title: title, message: message, preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "Confirm", style: .cancel) { action in
        let text = alertVC.textFields?.first?.text ?? ""
        completion(text)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    
    alertVC.addTextField { (textField) in
        textField.text = text
        textField.placeholder = placeholder
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
public func g_showPickerAlert(title: String? = nil, message: String? = nil, buttons: [String], buttonsStyles: [UIAlertAction.Style]? = nil, enabledButtons: [Bool]? = nil, completion: @escaping ((String, Int) -> ())) {
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

// ******************************* MARK: - Email

public typealias EmailAttachment = (data: Data, mimeType: String, fileName: String)

/// Tries to send email with MFMailComposeViewController first. If can't uses mailto: url scheme.
/// - parameter to: Addressee's email
/// - parameter title: Optional email title
/// - parameter body: Optional email body
public func g_sendEmail(to: String, title: String? = nil, body: String? = nil) {
    if !g_sendEmailUsingMailComposer(to: to, title: title, body: body, attachments: []) {
        g_sendEmailUsingMailto(to: to, title: title, body: body)
    }
}

/// Sends email with MFMailComposeViewController. Won't do anything if `MFMailComposeViewController.canSendMail()` returns false.
/// - parameter to: Addressee's email
/// - parameter title: Optional email title
/// - parameter body: Optional email body
/// - parameter attachments: Typles with data, mime type and file name.
/// - returns: false if can not send email
public func g_sendEmailUsingMailComposer(to: String, title: String? = nil, body: String? = nil, attachments: [EmailAttachment] = []) -> Bool {
    guard let vc = MFMailComposeViewController.create(to: [to]) else { return false }
    
    vc.setSubject(title ?? "")
    vc.setMessageBody(body ?? "", isHTML: false)
    attachments.forEach({
        vc.addAttachmentData($0.0, mimeType: $0.1, fileName: $0.2)
    })
    
    g_rootViewController.present(vc, animated: true, completion: nil)
    
    return true
}

/// Sends email using mailto: url scheme. Won't do anything if URL can not be composed.
/// - parameter to: Addressee's email
/// - parameter title: Optional email title
/// - parameter body: Optional email body
public func g_sendEmailUsingMailto(to: String, title: String? = nil, body: String? = nil) {
    guard var urlComponents = URLComponents(string: "mailto:\(to)") else { return }
    
    if let title = title {
        let item = URLQueryItem(name: "subject", value: title)
        urlComponents.addQueryItem(item)
    }
    
    if let body = body {
        let item = URLQueryItem(name: "body", value: body)
        urlComponents.addQueryItem(item)
    }
    
    guard let url = urlComponents.url else { return }
    
    g_sharedApplication.openURL(url)
}

// ******************************* MARK: - Network Activity

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

// ******************************* MARK: - Swizzle

/// Swizzles meta class methods
public func g_swizzleClassMethods(class: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
    guard class_isMetaClass(`class`) else { return }
    guard class_respondsToSelector(`class`, originalSelector) else { return }
    guard class_respondsToSelector(`class`, swizzledSelector) else { return }
    
    let originalMethod = class_getClassMethod(`class`, originalSelector)!
    let swizzledMethod = class_getClassMethod(`class`, swizzledSelector)!
    
    f_swizzleMethods(class: `class`, originalSelector: originalSelector, originalMethod: originalMethod, swizzledSelector: swizzledSelector, swizzledMethod: swizzledMethod)
}

/// Swizzles class methods
public func g_swizzleMethods(class: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
    guard !class_isMetaClass(`class`) else { return }
    guard class_respondsToSelector(`class`, originalSelector) else { return }
    guard class_respondsToSelector(`class`, swizzledSelector) else { return }
    
    let originalMethod = class_getInstanceMethod(`class`, originalSelector)!
    let swizzledMethod = class_getInstanceMethod(`class`, swizzledSelector)!
    
    f_swizzleMethods(class: `class`, originalSelector: originalSelector, originalMethod: originalMethod, swizzledSelector: swizzledSelector, swizzledMethod: swizzledMethod)
}

private func f_swizzleMethods(class: AnyClass, originalSelector: Selector, originalMethod: Method, swizzledSelector: Selector, swizzledMethod: Method) {
    let didAddMethod = class_addMethod(`class`, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
    
    if didAddMethod {
        class_replaceMethod(`class`, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

// ******************************* MARK: - Other Global Functions

/// Returns all classes that conforms to specified protocol. Protocol must be declared with @objc annotation.
/// Takes 0.003s - 0.02s on 5s device. Example usage:
///
///     let setupOnes: [SetupOnce.Type] = g_getClassesConformToProtocol(SetupOnce.self)
///     // or
///     let setupOnes = g_getClassesConformToProtocol(SetupOnce.self) as [SetupOnce.Type]
public func g_getClassesConformToProtocol<T>(_ protocol: Protocol) -> [T] {
    return APExtensionsLoader.getClassesConform(to: `protocol`).compactMap({ $0 as? T })
}

/// Returns all child classes for specified class. Not recursively.
/// Takes 0.015s on 5s device. Example usage:
///
///     let childClasses = g_getChildrenClasses(UIViewController.self)
public func g_getChildrenClasses<T: AnyObject>(of `class`: T.Type) -> [T.Type] {
    return APExtensionsLoader.getChildClasses(for: `class`).compactMap({ $0 as? T.Type })
}

/// Returns string prepresentation of object's pointer
public func g_getPointer(_ any: AnyObject) -> String {
    return Unmanaged<AnyObject>.passUnretained(any as AnyObject).toOpaque().debugDescription
}

public func g_Translate(_ string: String) -> String {
    return NSLocalizedString(string, comment: "")
}

/// Opens iOS Settings page for current application
public func g_openAppSettings() {
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.openURL(settingsURL)
}
