//
//  Configurable.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 6/16/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


/// Usually views might conform to this protocol so it's possible to pass view model without typecasting.
public protocol Configurable {
    /// Pass view model to view so it can configure itself.
    func configure(viewModel: Any)
}
