//
//  AlertController.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 4/26/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

//-----------------------------------------------------------------------------
// MARK: - Helper Class
//-----------------------------------------------------------------------------

private class AlertRootViewController: UIViewController {
    fileprivate var customPreferredStatusBarStyle = UIStatusBarStyle.lightContent
    fileprivate var customPrefersStatusBarHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return customPrefersStatusBarHidden
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return customPreferredStatusBarStyle
    }
}

//-----------------------------------------------------------------------------
// MARK: - Class Implementation
//-----------------------------------------------------------------------------

public class AlertController: UIAlertController {
    
    //-----------------------------------------------------------------------------
    // MARK: - Private Properties
    //-----------------------------------------------------------------------------
    
    private lazy var rootVC: AlertRootViewController = {
        let rootVC = AlertRootViewController()
        let topVc = g_topViewController
        
        rootVC.customPrefersStatusBarHidden = topVc?.prefersStatusBarHidden ?? false
        
        if (Bundle.main.object(forInfoDictionaryKey: "UIViewControllerBasedStatusBarAppearance") as! Bool?) ?? true {
            rootVC.customPreferredStatusBarStyle = topVc?.preferredStatusBarStyle ?? .default
        } else {
            if let barStyle = topVc?.navigationController?.navigationBar.barStyle {
                rootVC.customPreferredStatusBarStyle = barStyle == .black ? .lightContent : .default
            }
        }
        
        
        return rootVC
    }()
    
    private lazy var alertWindow: UIWindow? = {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.windowLevel = UIWindowLevelAlert
        alertWindow.rootViewController = self.rootVC
        
        return alertWindow
    }()
    
    //-----------------------------------------------------------------------------
    // MARK: - UIViewController Methods
    //-----------------------------------------------------------------------------
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        alertWindow?.isHidden = true
        alertWindow = nil
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Public Methods
    //-----------------------------------------------------------------------------
    
    public func present(animated: Bool) {
        alertWindow?.makeKeyAndVisible()
        alertWindow?.rootViewController?.present(self, animated: animated, completion: nil)
    }
}
