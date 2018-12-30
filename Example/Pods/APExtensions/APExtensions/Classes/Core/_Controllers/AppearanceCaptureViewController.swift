//
//  AppearanceCaptureViewController.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 2/9/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import UIKit


/// Can be used in overlaying windows to capture underlaying appearance and prevent it change.
/// Appearance captured on initialization.
public class AppearanceCaptureViewController: UIViewController {
    private var customPreferredStatusBarStyle = UIStatusBarStyle.lightContent
    private var customPrefersStatusBarHidden = false
    
    override public var prefersStatusBarHidden: Bool {
        return customPrefersStatusBarHidden
    }
    
    override public var preferredStatusBarStyle : UIStatusBarStyle {
        return customPreferredStatusBarStyle
    }
    
    // ******************************* MARK: - Initialization and Setup
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        onInitSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        onInitSetup()
    }
    
    private func onInitSetup() {
        let topVc = g_statusBarStyleTopViewController
        
        customPrefersStatusBarHidden = topVc?.prefersStatusBarHidden ?? false
        
        if (Bundle.main.object(forInfoDictionaryKey: "UIViewControllerBasedStatusBarAppearance") as! Bool?) ?? true {
            customPreferredStatusBarStyle = topVc?.preferredStatusBarStyle ?? .default
        } else {
            if let barStyle = topVc?.navigationController?.navigationBar.barStyle {
                customPreferredStatusBarStyle = barStyle == .black ? .lightContent : .default
            }
        }
    }
}
