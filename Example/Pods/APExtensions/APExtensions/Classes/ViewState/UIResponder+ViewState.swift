//
//  UIResponder+ViewState.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 2/19/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import UIKit


#if DEBUG
    private let c_debugBecomeFirstResponder = false
#else
    private let c_debugBecomeFirstResponder = false
#endif


private var c_becomeMainResponderAssociationKey = 0
private var c_becomeFirstResponderWhenPossibleAssociationKey = 0
private var c_becomeFirstResponderOnViewDidAppearAssociationKey = 0


public extension UIResponder {
    private var _viewController: UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
    
    private var _becomeMainResponder: Bool {
        get {
            return objc_getAssociatedObject(self, &c_becomeMainResponderAssociationKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &c_becomeMainResponderAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var _becomeFirstResponderWhenPossible: Bool {
        get {
            return objc_getAssociatedObject(self, &c_becomeFirstResponderWhenPossibleAssociationKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &c_becomeFirstResponderWhenPossibleAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var _becomeFirstResponderOnViewDidAppear: Bool {
        get {
            return objc_getAssociatedObject(self, &c_becomeFirstResponderOnViewDidAppearAssociationKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &c_becomeFirstResponderOnViewDidAppearAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // TODO: Become first responder on container controller become first responder (e.g. navigation or tab bar if child controller is main).
    /// Tells responder to become main responder. It means it'll become first when view has window and will try to restore it's state on willAppear/didAppear.
    ///
    /// Quote from Apple doc: "Never call this method on a view that is not part of an active view hierarchy. You can determine whether the view is onscreen, by checking its window property. If that property contains a valid window, it is part of an active view hierarchy. If that property is nil, the view is not part of a valid view hierarchy."
    ///
    /// Because configuration usually is made in `viewDidLoad` or `viewWillAppear` while `view` still might have `nil` `window` it's useful to delay `becomeFirstResponder` calls.
    @IBInspectable public var becomeMainRespoder: Bool {
        get {
            return _becomeMainResponder
        }
        set {
            guard newValue != _becomeMainResponder else { return }
            
            _becomeMainResponder = newValue
            
            if newValue {
                let vc = _viewController
                if vc?.viewState == .didAttach || vc?.viewState == .didAppear {
                    // Already appeared
                    becomeFirstResponder()
                    if c_debugBecomeFirstResponder { self.log("becomeMainRespoder") }
                    
                } else {
                    // Wait until appeared
                    var stateDidChangedToken: NSObjectProtocol! = nil
                    let handleNotification: (Notification) -> Void = { [weak self] notification in
                        guard let `self` = self, self._becomeMainResponder else {
                            // Object no longer exists or no longer notification no longer needed.
                            // Remove observer.
                            NotificationCenter.default.removeObserver(stateDidChangedToken)
                            return
                        }
                        // Assure notification for proper controller
                        guard self._viewController == notification.object as? UIViewController else { return }
                        // Assure view is loaded and has window
                        guard self._viewController?.isViewLoaded == true && self._viewController?.view.window != nil else { return }
                        // Assure it's appear notification
                        guard let viewState = notification.userInfo?["viewState"] as? UIViewController.ViewState else { return }
                        guard viewState == .didAttach || viewState == .willAppear || viewState == .didAppear else { return }
                        
                        self.becomeFirstResponder()
                        if c_debugBecomeFirstResponder { self.log("becomeMainRespoder") }
                    }
                    stateDidChangedToken = NotificationCenter.default.addObserver(forName: .UIViewControllerViewStateDidChange, object: vc, queue: nil, using: handleNotification)
                }
            } else {
                
            }
        }
    }
    
    /// Tells responder to become first when view has window.
    ///
    /// Quote from Apple doc: "Never call this method on a view that is not part of an active view hierarchy. You can determine whether the view is onscreen, by checking its window property. If that property contains a valid window, it is part of an active view hierarchy. If that property is nil, the view is not part of a valid view hierarchy."
    ///
    /// Because configuration usually is made in `viewDidLoad` or `viewWillAppear` while `view` still might have `nil` `window` it's useful to delay `becomeFirstResponder` calls.
    @IBInspectable public var becomeFirstResponderWhenPossible: Bool {
        get {
            return _becomeFirstResponderWhenPossible
        }
        set {
            guard newValue != _becomeFirstResponderWhenPossible else { return }
            
            _becomeFirstResponderWhenPossible = newValue
            
            if newValue {
                let vc = _viewController
                if vc?.viewState == .didAttach || vc?.viewState == .didAppear {
                    // Already appeared
                    _becomeFirstResponderWhenPossible = false
                    becomeFirstResponder()
                    if c_debugBecomeFirstResponder { self.log("becomeFirstResponderWhenPossible") }
                    
                } else {
                    // Wait until appeared
                    var stateDidChangedToken: NSObjectProtocol! = nil
                    let handleNotification: (Notification) -> Void = { [weak self] notification in
                        guard let `self` = self, self._becomeFirstResponderWhenPossible else {
                            // Object no longer exists or no longer notification no longer needed.
                            // Remove observer.
                            NotificationCenter.default.removeObserver(stateDidChangedToken)
                            return
                        }
                        // Assure notification for proper controller
                        guard self._viewController == notification.object as? UIViewController else { return }
                        // Assure view is loaded and has window
                        guard self._viewController?.isViewLoaded == true && self._viewController?.view.window != nil else { return }
                        
                        // Got our notification. Remove observer.
                        NotificationCenter.default.removeObserver(stateDidChangedToken)
                        
                        // Reset this flag so we can assign it again later if needed
                        self._becomeFirstResponderWhenPossible = false
                        
                        self.becomeFirstResponder()
                        if c_debugBecomeFirstResponder { self.log("becomeFirstResponderWhenPossible") }
                    }
                    stateDidChangedToken = NotificationCenter.default.addObserver(forName: .UIViewControllerViewStateDidChange, object: vc, queue: nil, using: handleNotification)
                }
            } else {
                
            }
        }
    }
    
    /// Tells responder to become first only after view did appear.
    ///
    /// Quote from Apple doc: "Never call this method on a view that is not part of an active view hierarchy. You can determine whether the view is onscreen, by checking its window property. If that property contains a valid window, it is part of an active view hierarchy. If that property is nil, the view is not part of a valid view hierarchy."
    ///
    /// Because configuration usually is made in `viewDidLoad` or `viewWillAppear` while `view` still might have `nil` `window` it's useful to delay `becomeFirstResponder` calls.
    @IBInspectable public var becomeFirstResponderOnViewDidAppear: Bool {
        get {
            return _becomeFirstResponderOnViewDidAppear
        }
        set {
            guard newValue != becomeFirstResponderOnViewDidAppear else { return }
            
            _becomeFirstResponderOnViewDidAppear = newValue
            
            if newValue {
                let vc = _viewController
                if vc?.viewState == .didAppear {
                    // Already appeared
                    _becomeFirstResponderOnViewDidAppear = false
                    becomeFirstResponder()
                    if c_debugBecomeFirstResponder { self.log("becomeFirstResponderOnViewDidAppear") }
                    
                } else {
                    // Wait until appeared
                    var token: NSObjectProtocol!
                    token = NotificationCenter.default.addObserver(forName: .UIViewControllerViewDidAppear, object: vc, queue: nil) { [weak self] notification in
                        guard let `self` = self, self._becomeFirstResponderOnViewDidAppear else {
                            // Object no longer exists or no longer notification no longer needed.
                            // Remove observer.
                            NotificationCenter.default.removeObserver(token)
                            return
                        }
                        // Assure notification for proper controller
                        guard self._viewController == notification.object as? UIViewController else { return }
                        
                        // Got our notification. Remove observer.
                        NotificationCenter.default.removeObserver(token)
                        
                        // Reset this flag so we can assign it again later if needed
                        self._becomeFirstResponderOnViewDidAppear = false
                        self.becomeFirstResponder()
                        if c_debugBecomeFirstResponder { self.log("becomeFirstResponderOnViewDidAppear") }
                    }
                }
            } else {
                
            }
        }
    }
    
    // ******************************* MARK: - Private Methods
    
    private func log(_ string: String) {
        let pointer = Unmanaged<AnyObject>.passUnretained(self).toOpaque().debugDescription
        let className = "\(type(of: self))"
        print("\(pointer) - \(className) - \(string)")
    }
}
