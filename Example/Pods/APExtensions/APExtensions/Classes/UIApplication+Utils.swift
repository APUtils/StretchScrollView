//
//  UIApplication+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 7/14/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit
import MessageUI


public extension UIApplication {
    /// Initiates call to `phone`
    public static func makeCall(phone: String) {
        let urlString = "telprompt://\(phone)"
        guard let url = URL(string: urlString) else { return }
        
        shared.openURL(url)
    }
    
    /// Tries to send email with MFMailComposeViewController first. If can't uses mailto: url scheme
    public static func sendEmail(to: String) {
        if let vc = MFMailComposeViewController.create(to: [to]) {
            g_rootViewController.present(vc, animated: true, completion: nil)
        } else {
            let urlString = "mailto://\(to)"
            guard let url = URL(string: urlString) else { return }
            
            shared.openURL(url)
        }
    }
}
