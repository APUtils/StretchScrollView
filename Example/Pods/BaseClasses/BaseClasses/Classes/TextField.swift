//
//  TextField.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 29/05/16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit


/// TextField with `Done` default button and close keyboard when tap
open class TextField: UITextField {
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization
    //-----------------------------------------------------------------------------
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Private methods
    //-----------------------------------------------------------------------------
    
    private func setup() {
        returnKeyType = .done
        if delegate == nil { delegate = self }
    }
}

//-----------------------------------------------------------------------------
// MARK: - UITextFieldDelegate
//-----------------------------------------------------------------------------

extension TextField: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
}
