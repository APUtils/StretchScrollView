//
//  ScrollView.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 19.05.16.
//  Copyright © 2016 Anton Plebanovich. All rights reserved.
//

import UIKit


/// ScrollView with decreased button touch delay and ability to show message when content is empty.
/// It also have activity indicator that always stays in center.
open class ScrollView: UIScrollView {
    
    //-----------------------------------------------------------------------------
    // MARK: - UIView Properties
    //-----------------------------------------------------------------------------
    
    open override var contentSize: CGSize {
        didSet {
            guard contentSize != oldValue else { return }
            
            configure()
        }
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - @IBInspectable
    //-----------------------------------------------------------------------------
    
    /// Text displayed in the middle of table view when it's content is empty
    @IBInspectable public var emptyText: String? {
        didSet {
            emptyLabel.text = emptyText
            configure()
            layout()
        }
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Private Properties
    //-----------------------------------------------------------------------------
    
    /// Label that displays `emptyText` string. You could configure it's params, but it's still better to set text using `emptyText` property.
    private(set) public lazy var emptyLabel: UILabel = {
        let emptyLabel = UILabel()
        emptyLabel.numberOfLines = 0
        emptyLabel.text = emptyText
        
        return emptyLabel
    }()
    
    /// Activity indicator that always stays in center.
    private(set) public lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        
        return activityIndicatorView
    }()
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization and Setup
    //-----------------------------------------------------------------------------
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        setupFastTouches()
        addSubview(emptyLabel)
        addSubview(activityIndicatorView)
        configure()
    }
    
    private func setupFastTouches() {
        delaysContentTouches = false
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Configuration
    //-----------------------------------------------------------------------------
    
    private func configure() {
        configureEmptyLabel()
    }
    
    private func configureEmptyLabel() {
        emptyLabel.isHidden = contentSize.height != 0 || contentSize.width != 0 || emptyText == nil || emptyText?.isEmpty == true
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - UIView Overrides
    //-----------------------------------------------------------------------------
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    private func layout() {
        layoutEmptyLabel()
        layoutActivityIndicatorView()
    }
    
    private func layoutEmptyLabel() {
        emptyLabel.sizeToFit()
        emptyLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private func layoutActivityIndicatorView() {
        bringSubviewToFront(activityIndicatorView)
        activityIndicatorView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - UIScrollView Methods
    //-----------------------------------------------------------------------------
    
    override open func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }
}
