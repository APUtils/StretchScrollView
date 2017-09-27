//
//  ViewController.swift
//  StretchScrollView
//
//  Created by Anton Plebanovich on 07/20/2017.
//  Copyright (c) 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
}
