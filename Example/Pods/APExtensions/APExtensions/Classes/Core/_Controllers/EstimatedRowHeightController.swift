//
//  EstimatedRowHeightController.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 8/2/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import UIKit


/// Controller that improves UITableView scrolling and animation experience.
/// - Note: You should assign tableView's `delegate` first and then create
/// and store `EstimatedRowHeightController`. Everything else is automatic.
class EstimatedRowHeightController: NSObject, UITableViewDelegate {
    
    // ******************************* MARK: - Private Properties
    
    private let tableView: UITableView
    private let originalTableViewDelegate: UITableViewDelegate?
    private var estimatedHeights: [IndexPath: CGFloat] = [:]
    
    // ******************************* MARK: - Initialization and Setup
    
    private override init() { fatalError("Use init(tableView:) instead") }
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.originalTableViewDelegate = tableView.delegate
        super.init()
        tableView.delegate = self
    }
    
    deinit {
        tableView.delegate = originalTableViewDelegate
    }
    
    // ******************************* MARK: - NSObject Methods
    
    override func responds(to aSelector: Selector!) -> Bool {
        var responds = super.responds(to: aSelector)
        
        if let originalTableViewDelegate = originalTableViewDelegate {
            responds = responds || originalTableViewDelegate.responds(to: aSelector)
        }
        
        return responds
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let target = super.forwardingTarget(for: aSelector) {
            return target
        } else if let originalTableViewDelegate = originalTableViewDelegate, originalTableViewDelegate.responds(to: aSelector) {
            return originalTableViewDelegate
        } else {
            return nil
        }
    }
    
    // ******************************* MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = originalTableViewDelegate?.tableView?(tableView, estimatedHeightForRowAt: indexPath) {
            return height
        } else {
            return estimatedHeights[indexPath] ?? UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        estimatedHeights[indexPath] = cell.bounds.height
        originalTableViewDelegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        estimatedHeights[indexPath] = cell.bounds.height
        originalTableViewDelegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
}
