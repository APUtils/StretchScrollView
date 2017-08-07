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
private let TopBarsHeight: CGFloat = StatusBarHeight + NavigationBarHeight

//-----------------------------------------------------------------------------
// MARK: - Class Implementation
//-----------------------------------------------------------------------------

/// Provides functionality to enlarge title image and hide overlays when scrolling down. When scrolling up it allows to
/// animate background of navigation bar.
/// - note: Title image constraints/fill mode should be configured properly for resizing to work. Controller configures
/// top and height constraints only.
public class StretchScrollView: ScrollView {
    
    //-----------------------------------------------------------------------------
    // MARK: - @IBInspectable
    //-----------------------------------------------------------------------------
    
    /// StretchScrollView will manage navigation bar transparency by itself.
    /// You could disable this option to manage it by yourself or to disable navigation bar animations.
    @IBInspectable var manageNavigationBarTransparency: Bool = true
    
    /// In case of transparent navigation bar you may specify background color that will appear when you scroll up.
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
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization and Setup
    //-----------------------------------------------------------------------------
    
    deinit {
        navigationBarBackgroundView.removeFromSuperview()
    }
    
    private func setup() {
        setupProperties()
        setupNotifications()
        setupNavigationBar()
        setupImageViewConstraints()
        configure()
    }
    
    private func setupProperties() {
        delegate = self
        
        fadeViews?.forEach({ _fadeViews.add($0) })
        fadeViews = nil
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onViewWillAppear(_:)), name: .UIViewControllerViewWillAppear, object: viewController)
        NotificationCenter.default.addObserver(self, selector: #selector(onViewWillDisappear(_:)), name: .UIViewControllerViewWillDisappear, object: viewController)
    }
    
    private func setupNavigationBar() {
        if manageNavigationBarTransparency {
            saveTransparencyState(replace: false)
            makeTransparent()
            viewController?.automaticallyAdjustsScrollViewInsets = false
        }
        
        navigationBarBackgroundView.isUserInteractionEnabled = false
        navigationBarBackgroundView.backgroundColor = navigationBackgroundColor
        navigationBarBackgroundView.frame = CGRect(x: 0, y: -StatusBarHeight, width: UIScreen.main.bounds.width, height: TopBarsHeight)
        navigationBar?.insertSubview(navigationBarBackgroundView, at: 0)
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
        
        let compensatedContentOffsetY = contentOffset.y + contentInset.top
        
        let newTopOffset = compensatedContentOffsetY
        cstrImageViewTop.constant = min(0, newTopOffset)
        
        let newHeight = max(defaultHeight, defaultHeight - compensatedContentOffsetY)
        cstrImageViewHeight.constant = newHeight
    }
    
    private func configureVisibility() {
        // Assure it's on zero position
        navigationBar?.insertSubview(navigationBarBackgroundView, at: 0)
        
        let compensatedContentOffsetY = contentOffset.y + contentInset.top
        
        // Fade views and navigation bar
        var newAlpha = (FadeOutOffset + compensatedContentOffsetY) / FadeOutOffset
        newAlpha = max(0, newAlpha)
        newAlpha = min(1, newAlpha)
        _fadeViews.allObjects.forEach { $0.alpha = newAlpha }
        
        // Navigation bar alpha won't be changed if content inset top is not zero or navigation bar is not translucent.
        let shouldChangeNavigationBarAlpha = contentInset.top == 0 && navigationBar?.isTranslucent == true
        if shouldChangeNavigationBarAlpha {
            navigationBar?.alpha = newAlpha
        }
        
        // Navigation bar background alpha
        let fadeInFinishDistance = NavigationFadeInFinishOffset
        let startFadeInDistance = min(fadeInFinishDistance, 0)
        let distance = fadeInFinishDistance - startFadeInDistance
        var backgroundNewAlpha = (startFadeInDistance + compensatedContentOffsetY) / distance
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
    // MARK: - Public Methods
    //-----------------------------------------------------------------------------
    
    public func addFadeViews(_ views: [UIView]) {
        views.forEach { _fadeViews.add($0) }
        configure()
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Private methods - Notifications
    //-----------------------------------------------------------------------------
    
    @objc private func onViewWillDisappear(_ notification: Notification) {
        navigationBarBackgroundView.alpha = 0
        
        if manageNavigationBarTransparency {
            restoreTransparencyState()
        }
    }
    
    @objc private func onViewWillAppear(_ notification: Notification) {
        if manageNavigationBarTransparency {
            saveTransparencyState(replace: false)
            makeTransparent()
        }
        
        configureVisibility()
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Private Methods - Transparency State
    //-----------------------------------------------------------------------------
    
    struct TransparencyState {
        let isTranslucent: Bool
        let backgroundImage: UIImage?
        let shadowImage: UIImage?
    }
    
    private var transparencyState: TransparencyState?
    
    func saveTransparencyState(replace: Bool) {
        guard replace || transparencyState == nil, let navigationBar = navigationBar else { return }
        
        transparencyState = TransparencyState(isTranslucent: navigationBar.isTranslucent, backgroundImage: navigationBar.backgroundImage(for: .default), shadowImage: navigationBar.shadowImage)
    }
    
    func restoreTransparencyState() {
        guard let transparencyState = transparencyState else { return }
        
        navigationBar?.isTranslucent = transparencyState.isTranslucent
        navigationBar?.setBackgroundImage(transparencyState.backgroundImage, for: .default)
        navigationBar?.shadowImage = transparencyState.shadowImage
    }
    
    func makeTransparent() {
        navigationBar?.isTranslucent = true
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
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
