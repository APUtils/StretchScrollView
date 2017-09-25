//
//  LabelLikeTextView.swift
//  Base Classes
//
//  Created by Anton Plebanovich on 9/21/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


/// Text view that acts like UILabel (self sizing, can not be edit or scroll),
/// but has various detections (address, links, etc) that UITextView has.
/// Also process clicks on links.
open class LabelLikeTextView: SelfResizableTextView {
    
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
    
    /// Init with custom `layoutManager`
    public convenience init(layoutManager: NSLayoutManager) {
        let storage = NSTextStorage()
        storage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: .zero)
        layoutManager.addTextContainer(textContainer)
        
        self.init(frame: .zero, textContainer: textContainer)
    }
    
    private func setup() {
        isSelectable = true
        isEditable = false
        dataDetectorTypes = [.all]
    }
}
