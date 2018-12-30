//
//  CellInformation.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 9/19/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


/// Minimum information required to display cell in table view
public protocol TableViewCellInformation {
    /// Cell class to dequeue
    var cellClass: UITableViewCell.Type { get }
    
    /// Cell height
    var cellHeight: CGFloat { get }
}

/// Minimum information required to display cell in table view
public protocol TableViewConfigurableCellInformation {
    /// Cell class to dequeue
    var cellClass: (UITableViewCell & Configurable).Type { get }
    
    /// Cell height
    var cellHeight: CGFloat { get }
}
