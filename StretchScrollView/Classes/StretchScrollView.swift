//
//  StretchScrollView.swift
//  StretchScrollView
//
//  Created by Anton Plebanovich on 7/14/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit
import APExtensions
import BaseClasses

//-----------------------------------------------------------------------------
// MARK: - Constants
//-----------------------------------------------------------------------------

private let FadeOutOffset: CGFloat = 60
private let NavigationFadeInFinishOffset: CGFloat = 60
private let StatusBarHeight: CGFloat = 20
private let NavigationBarHeight: CGFloat = 44

//-----------------------------------------------------------------------------
// MARK: - Helper Extension
//-----------------------------------------------------------------------------

/// Gets view's UIViewController.
extension UIView {
    public var viewController: UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
}

//-----------------------------------------------------------------------------
// MARK: - Class Implementation
//-----------------------------------------------------------------------------

/// Provides functionality to enlarge title image and hide overlays when scrolling down. When scrolling up it allows to
/// animate background of navigation bar.
/// - note: Title image constraints/fill mode should be configured properly for resizing to work. Controller configures
/// top and height constraints only.
public class StretchScrollView: ScrollView {
    
    //-----------------------------------------------------------------------------
    // MARK: - UIScrollView Properties
    //-----------------------------------------------------------------------------
    
    public override var contentInset: UIEdgeInsets {
        get {
            return super.contentInset
        }
        set {
            // Top content inset makes no sense for StretchScrollView so assure it's always 0.
            var newContentInset = newValue
            newContentInset.top = 0
            
            super.contentInset = newContentInset
        }
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - @IBInspectable
    //-----------------------------------------------------------------------------
    
    @IBInspectable var navigationBackgroundColor: UIColor = .clear
    
    //-----------------------------------------------------------------------------
    // MARK: - @IBOutlets
    //-----------------------------------------------------------------------------
    
    @IBOutlet private weak var stretchedView: UIView!
    @IBOutlet private var fadeViews: [UIView]?
    
    //-----------------------------------------------------------------------------
    // MARK: - Private properties
    //-----------------------------------------------------------------------------
    
    private var _fadeViews = NSHashTable<UIView>(options: [.weakMemory])
    
    private var navigationBar: UINavigationBar? {
        return viewController?.navigationController?.navigationBar
    }
    
    private let navigationBarBackgroundView = UIView()
    private var cstrImageViewTop: NSLayoutConstraint?
    private var cstrImageViewHeight: NSLayoutConstraint?
    private var defaultHeight: CGFloat = 0
    private var ignoreStatusBarHeight: Bool = false
    
    private var topBarsHeight: CGFloat {
        return ignoreStatusBarHeight ? NavigationBarHeight : StatusBarHeight + NavigationBarHeight
    }
    
    private var fadeOutOffset: CGFloat {
        return ignoreStatusBarHeight ? FadeOutOffset - StatusBarHeight : FadeOutOffset
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization and Setup
    //-----------------------------------------------------------------------------
    
    deinit {
        navigationBarBackgroundView.removeFromSuperview()
    }
    
    private func setup() {
        APExtensions.prepare()
        setupProperties()
        setupNotifications()
        setupNavigationBar()
        setupImageViewConstraints()
        configure()
    }
    
    private func setupProperties() {
        delegate = self
        contentInset = .zero
        
        fadeViews?.forEach({ _fadeViews.add($0) })
        fadeViews = nil
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onViewWillAppear(_:)), name: .UIViewControllerViewWillAppear, object: viewController)
        NotificationCenter.default.addObserver(self, selector: #selector(onViewWillDisappear(_:)), name: .UIViewControllerViewWillDisappear, object: viewController)
    }
    
    private func setupNavigationBar() {
        navigationBarBackgroundView.isUserInteractionEnabled = false
        navigationBarBackgroundView.backgroundColor = navigationBackgroundColor
        navigationBarBackgroundView.frame = CGRect(x: 0, y: ignoreStatusBarHeight ? 0 : -StatusBarHeight, width: UIScreen.main.bounds.width, height: topBarsHeight)
        navigationBar?.insertSubview(navigationBarBackgroundView, at: 0)
        
        // Ignore status bar height?
        self.navigationBar?.subviews.forEach {
            if let imgViewBackground = $0 as? UIImageView, imgViewBackground.bounds.size.height == NavigationBarHeight {
                ignoreStatusBarHeight = true
            }
        }
    }
    
    private func setupImageViewConstraints() {
        guard let superview = stretchedView.superview else { return }
        
        for constraint in superview.constraints {
            if (constraint.firstItem === stretchedView && constraint.secondItem === superview && constraint.firstAttribute == .top) ||
                (constraint.secondItem === stretchedView && constraint.firstItem === superview && constraint.secondAttribute == .top) {
                
                self.cstrImageViewTop = constraint
                break
            }
        }
        
        for constraint in stretchedView.constraints {
            if (constraint.firstItem === stretchedView && constraint.firstAttribute == .height) {
                self.cstrImageViewHeight = constraint
                self.defaultHeight = constraint.constant
                break
            }
        }
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Configuration
    //-----------------------------------------------------------------------------
    
    fileprivate func configure() {
        configureStretchedView()
        configureVisibility()
    }
    
    private func configureStretchedView() {
        guard let cstrImageViewTop = cstrImageViewTop, let cstrImageViewHeight = cstrImageViewHeight else { return }
        
        let contentOffsetY = contentOffset.y
        
        let newTopOffset = contentOffsetY
        cstrImageViewTop.constant = min(0, newTopOffset)
        
        let newHeight = max(defaultHeight, defaultHeight - contentOffsetY)
        cstrImageViewHeight.constant = newHeight
    }
    
    private func configureVisibility() {
        // Assure it's on zero position
        navigationBar?.insertSubview(navigationBarBackgroundView, at: 0)
        
        let contentOffsetY = contentOffset.y
        
        // Fade views and navigation bar
        var newAlpha = (fadeOutOffset + contentOffsetY) / fadeOutOffset
        newAlpha = max(0, newAlpha)
        newAlpha = min(1, newAlpha)
        _fadeViews.allObjects.forEach { $0.alpha = newAlpha }
        navigationBar?.alpha = newAlpha
        
        // Navigation bar background alpha
        let fadeInFinishDistance = NavigationFadeInFinishOffset
        let startFadeInDistance = min(fadeInFinishDistance, 0)
        let distance = fadeInFinishDistance - startFadeInDistance
        var backgroundNewAlpha = (startFadeInDistance + contentOffsetY) / distance
        backgroundNewAlpha = max(0, backgroundNewAlpha)
        backgroundNewAlpha = min(1, backgroundNewAlpha)
        navigationBarBackgroundView.alpha = backgroundNewAlpha
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - UIView Methods
    //-----------------------------------------------------------------------------
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Private methods - Notifications
    //-----------------------------------------------------------------------------
    
    @objc private func onViewWillDisappear(_ notification: Notification) {
        navigationBarBackgroundView.alpha = 0
    }
    
    @objc private func onViewWillAppear(_ notification: Notification) {
        configureVisibility()
    }
}

//-----------------------------------------------------------------------------
// MARK: - UIScrollViewDelegate
//-----------------------------------------------------------------------------

extension StretchScrollView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        configure()
    }
}
