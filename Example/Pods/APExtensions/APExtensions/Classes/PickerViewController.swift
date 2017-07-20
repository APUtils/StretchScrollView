//
//  PickerViewController.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 23.09.16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit


public class PickerViewController: UIAlertController {
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization
    //-----------------------------------------------------------------------------
    
    @objc public static func show(title: String?, message: String?, buttons: [String], completion: @escaping ((String, Int) -> ())) {
        show(title: title, message: message, buttons: buttons, buttonsStyles: nil, enabledButtons: nil, completion: completion)
    }
    
    public static func show(title: String? = nil, message: String? = nil, buttons: [String], buttonsStyles: [UIAlertActionStyle]? = nil, enabledButtons: [Bool]? = nil, completion: @escaping ((String, Int) -> ())) {
        let vc = AlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        vc.addAction(cancel)
        
        for (index, button) in buttons.enumerated() {
            let buttonStyle = buttonsStyles?[index] ?? .default
            let action = UIAlertAction(title: button, style: buttonStyle, handler: { _ in
                completion(button, index)
            })
            
            if let enabledButtons = enabledButtons, enabledButtons.count == buttons.count {
                action.isEnabled = enabledButtons[index]
            }
            
            vc.addAction(action)
        }
        
        vc.present(animated: true)
    }
}
