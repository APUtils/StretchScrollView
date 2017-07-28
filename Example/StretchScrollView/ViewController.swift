//
//  ViewController.swift
//  StretchScrollView
//
//  Created by Anton Plebanovich on 07/20/2017.
//  Copyright (c) 2017 Anton Plebanovich. All rights reserved.
//

import UIKit
import APExtensions
import StretchScrollView


class ViewController: UIViewController {
    
    //-----------------------------------------------------------------------------
    // MARK: - @IBOutlets
    //-----------------------------------------------------------------------------
    
    @IBOutlet private weak var scrollView: StretchScrollView!
    
    //-----------------------------------------------------------------------------
    // MARK: - UIViewController Methods
    //-----------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Making navigation bar transparent so it's background can be animated
        navigationController?.navigationBar.setTransparent(true)
        
        // Because navigation bar is transparent make image stick to top
        // You could also configure this option in storyboard, just don't forget
        automaticallyAdjustsScrollViewInsets = false
    }
}
