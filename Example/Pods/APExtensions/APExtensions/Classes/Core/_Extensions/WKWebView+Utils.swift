//
//  WKWebView+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 1/20/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import WebKit


public extension WKWebView {
    /// Loads url from given string if possible
    public func load(_ string: String) {
        guard let url = URL(string: string) else { return }
        
        load(url)
    }
    
    /// Loads url
    public func load(_ url: URL) {
        load(URLRequest(url: url))
    }
    
    /// Shows empty page
    public func clear() {
        load("about:blank")
    }
}
