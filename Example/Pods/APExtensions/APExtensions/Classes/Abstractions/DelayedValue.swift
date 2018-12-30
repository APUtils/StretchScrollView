//
//  DelayedValue.swift
//  Commons
//
//  Created by Anton Plebanovich on 9/20/17.
//  Copyright © 2017 Convene. All rights reserved.
//

import Foundation


/// Simple abstraction that simplifies working with values that needs some time to be fetched.
/// Kind of promise. Good to use in view models to simplify view configuration.
public class DelayedValue<T> {
    
    // ******************************* MARK: - Types
    
    public typealias GetValue = (_ completion: @escaping UseValue) -> ()
    public typealias UseValue = (_ value: T) -> ()
    
    // ******************************* MARK: - Public Properties
    
    /// Returns value if it's available or nil.
    private(set) public var value: T?
    
    // ******************************* MARK: - Private Properties
    
    private var getValue: GetValue?
    private var onValueAvaliable: UseValue?
    
    // ******************************* MARK: - Initialization and Setup
    
    /// Allows to init DelayedValue without getValue closure in case it might be needed to set it later.
    public init() {
        setup()
    }
    
    /// Init DelayedValue with getValue closure
    public init(getValue: @escaping GetValue) {
        self.getValue = getValue
        
        setup()
    }
    
    private func setup() {
        startGettingValue()
    }
    
    // ******************************* MARK: - Public Methods
    
    /// Allows to set getValue closure. It'll be executed right after and call onValueAvaliable when available.
    public func setGetValueClosure(_ getValue: @escaping GetValue) {
        self.getValue = getValue
        startGettingValue()
    }
    
    /// Sets onValueAvailable closure that will be called when value available or immediately if value already available.
    public func onValueAvailable(_ onValueAvaliable: @escaping UseValue) {
        if let value = value {
            onValueAvaliable(value)
        } else {
            self.onValueAvaliable = onValueAvaliable
        }
    }
    
    // ******************************* MARK: - Private Methods
    
    private func startGettingValue() {
        guard let getValue = getValue else { return }
        
        getValue { [weak self] value in
            guard let `self` = self else { return }
            
            self.value = value
            self.onValueAvaliable?(value)
        }
    }
}
