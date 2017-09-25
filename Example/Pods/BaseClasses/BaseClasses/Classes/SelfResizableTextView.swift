//
//  SelfResizableTextView.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 9/20/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


/// Text view with zero paddings between text and frame and self sizable depending on content. Is not scrollable.
open class SelfResizableTextView: TextView {
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization and Setup
    //-----------------------------------------------------------------------------
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        isScrollEnabled = false
        textContainer.heightTracksTextView = true
        textContainer.widthTracksTextView = true
    }
}
