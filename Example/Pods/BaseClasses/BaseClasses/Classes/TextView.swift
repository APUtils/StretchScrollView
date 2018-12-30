//
//  TextView.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 9/20/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


/// Text view with zero paddings between text and frame
open class TextView: UITextView {
    
    // ******************************* MARK: - IBInspectable
    
    @IBInspectable public var textSideInset: CGFloat = 0 {
        didSet {
            configureInsets()
        }
    }
    
    // ******************************* MARK: - Initialization and Setup
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        textContainer.lineFragmentPadding = 0
        
        configure()
    }
    
    // ******************************* MARK: - Configuration
    
    private func configure() {
        configureInsets()
    }
    
    private func configureInsets() {
        let insets = UIEdgeInsets(top: 0, left: textSideInset, bottom: 0, right: textSideInset)
        textContainerInset = insets
    }
}
