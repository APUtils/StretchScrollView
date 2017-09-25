//
//  CellInformation.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 9/19/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


/// Minimum information required to display cell in table view
public protocol TableViewCellInformation {
    var cellClass: UITableViewCell.Type { get }
    var cellHeight: CGFloat { get }
}

/// Minimum information required to display cell in table view
public protocol TableViewConfigurableCellInformation {
    var cellClass: (UITableViewCell & Configurable).Type { get }
    var cellHeight: CGFloat { get }
}
