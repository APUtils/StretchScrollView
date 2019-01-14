//
//  FromCodeVC.swift
//  StretchScrollView
//
//  Created by Anton Plebanovich on 1/14/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

import APExtensions
import StretchScrollView


final class FromCodeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = StretchScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "sarah"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        scrollView.addSubview(imageView)
        
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        // Should be called last
        scrollView.setStretchedView(imageView)
    }
}
