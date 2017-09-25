//
//  DelayedValue.swift
//  Commons
//
//  Created by Anton Plebanovich on 9/20/17.
//  Copyright © 2017 Convene. All rights reserved.
//

import Foundation


public class DelayedValue<T> {
    
    //-----------------------------------------------------------------------------
    // MARK: - Types
    //-----------------------------------------------------------------------------
    
    public typealias GetValue = (_ completion: @escaping UseValue) -> ()
    public typealias UseValue = (_ value: T) -> ()
    
    //-----------------------------------------------------------------------------
    // MARK: - Public Properties
    //-----------------------------------------------------------------------------
    
    private(set) public var value: T?
    
    //-----------------------------------------------------------------------------
    // MARK: - Private Properties
    //-----------------------------------------------------------------------------
    
    private var getValue: GetValue
    private var onValueAvaliable: UseValue?
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization and Setup
    //-----------------------------------------------------------------------------
    
    public init(getValue: @escaping GetValue) {
        self.getValue = getValue
        
        setup()
    }
    
    private func setup() {
        getValue { value in
            self.value = value
            self.onValueAvaliable?(value)
        }
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Public Methods
    //-----------------------------------------------------------------------------
    
    public func onValueAvailable(_ onValueAvaliable: @escaping UseValue) {
        if let value = value {
            onValueAvaliable(value)
        } else {
            self.onValueAvaliable = onValueAvaliable
        }
    }
}
