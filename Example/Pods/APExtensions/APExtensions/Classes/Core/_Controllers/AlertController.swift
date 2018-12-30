//
//  AlertController.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 4/26/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

// ******************************* MARK: - Class Implementation

public final class AlertController: UIAlertController {
    
    // ******************************* MARK: - Types
    
    public enum PresentationStyle {
        /// Present in separate window
        case window
        
        /// Present in key window from top presented controller
        case topController
    }
    
    // ******************************* MARK: - Classes Properties
    
    public static var presentationStyle: PresentationStyle = .window
    
    // ******************************* MARK: - Private Properties
    
    private lazy var alertWindow: UIWindow? = .createAlert()
    
    // ******************************* MARK: - UIViewController Methods
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if AlertController.presentationStyle == .window {
            alertWindow?.isHidden = true
            alertWindow = nil
        }
    }
    
    // ******************************* MARK: - Public Methods
    
    public func present(animated: Bool, completion: (() -> Void)? = nil) {
        if let popover = popoverPresentationController {
            // Prevent crash by targeting bottom of the screen
            if popover.sourceView == nil && popover.sourceRect == .zero {
                if AlertController.presentationStyle == .window, let alertWindow = alertWindow {
                    popover.sourceView = alertWindow
                    popover.sourceRect = CGRect(x: alertWindow.bounds.size.width / 2, y: alertWindow.bounds.size.height, width: 0, height: 0)
                } else if let view = g_topViewController?.view {
                    popover.sourceView = view
                    popover.sourceRect = CGRect(x: view.bounds.size.width / 2, y: view.bounds.size.height, width: 0, height: 0)
                } else {
                    print("AlertController: can not get sourceView and sourceRect for presentation")
                    return
                }
            }
        }
        
        g_performInMain {
            switch AlertController.presentationStyle {
            case .window:
                self.alertWindow?.makeKeyAndVisible()
                self.alertWindow?.rootViewController?.present(self, animated: animated, completion: completion)
                
            case .topController:
                g_topViewController?.present(self, animated: animated, completion: completion)
            }
        }
    }
}
