//
//  UIWebView+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 1/20/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension UIWebView {
    /// Loads url from given string if possible
    public func load(urlString: String) {
        load(url: URL(string: urlString))
    }
    
    /// Loads url
    public func load(url: URL?) {
        guard let url = url else { return }
        
        let request = URLRequest(url: url)
        loadRequest(request)
    }
    
    /// Shows empty page
    public func clear() {
        load(urlString: "about:blank")
    }
}
