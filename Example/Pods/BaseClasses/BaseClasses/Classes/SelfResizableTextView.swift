//
//  SelfResizableTextView.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 9/20/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


/// Text view with zero paddings between text and frame and self sizable depending on content.
open class SelfResizableTextView: TextView {
    
    //-----------------------------------------------------------------------------
    // MARK: - Public properties
    //-----------------------------------------------------------------------------
    
    override open var contentSize: CGSize { didSet { didSetContentSize() } }
    
    // ******************************* MARK: - Private Properties
    
    private var previousContentSize = CGSize.zero
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization and Setup
    //-----------------------------------------------------------------------------
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setup() {
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onTextChange(_:)), name: UITextView.textDidChangeNotification, object: self)
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - UIView Overrides
    //-----------------------------------------------------------------------------
    
    override open var intrinsicContentSize : CGSize {
        var intrinsicContentSize = contentSize
        intrinsicContentSize.height = max(intrinsicContentSize.height, 33)
        
        return intrinsicContentSize
    }
    
    // Disabling autoscroll
    override open func scrollRectToVisible(_ rect: CGRect, animated: Bool) {}
    
    // ******************************* MARK: - Notifications
    
    @objc private func onTextChange(_ notification: Notification) {
        // Animating to new size
        UIView.animate(withDuration: 0.05, delay: 0, options: .beginFromCurrentState, animations: {
            self._rootView.layoutIfNeeded()
            self.contentOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        }, completion: nil)
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Private Methods - didSet/willSet
    //-----------------------------------------------------------------------------
    
    fileprivate func didSetContentSize() {
        guard previousContentSize != contentSize else { return }
        
        previousContentSize = contentSize
        invalidateIntrinsicContentSize()
    }
}
