//
//  StretchScrollView.swift
//  StretchScrollView
//
//  Created by Anton Plebanovich on 7/14/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

#if COCOAPODS
import APExtensions
#else
import APExtensionsViewState
#endif

//-----------------------------------------------------------------------------
// MARK: - Constants
//-----------------------------------------------------------------------------

private let FadeOutOffset: CGFloat = 60
private let NavigationFadeInFinishOffset: CGFloat = 60

//-----------------------------------------------------------------------------
// MARK: - Class Implementation
//-----------------------------------------------------------------------------

/// Provides functionality to enlarge title image and hide overlays when scrolling down. When scrolling up it allows to
/// animate background of navigation bar.
/// - note: Title image constraints/fill mode should be configured properly for resizing to work. Controller configures
/// top and height constraints only.
public class StretchScrollView: UIScrollView {
    
    //-----------------------------------------------------------------------------
    // MARK: - Enums
    //-----------------------------------------------------------------------------
    
    enum ResizeType {
        case none
        case topAndHeight(topConstraint: NSLayoutConstraint, heightConstraint: NSLayoutConstraint, defaultHeight: CGFloat)
        case topAndSides(topConstraint: NSLayoutConstraint, leftConstraint: NSLayoutConstraint, rightConstraint: NSLayoutConstraint, aspectRatio: CGFloat)
        
        var isNone: Bool {
            switch self {
            case .none: return true
            default: return false
            }
        }
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - @IBInspectable
    //-----------------------------------------------------------------------------
    
    /// StretchScrollView will manage navigation bar transparency by itself.
    /// You could disable this option to manage it by yourself or to disable navigation bar animations.
    /// Default is `true`.
    @IBInspectable var manageNavigationBarTransparency: Bool = true
    
    /// In case of transparent navigation bar you may specify background color that will appear when you scroll up.
    /// Default is clear color.
    @IBInspectable var navigationBackgroundColor: UIColor = .clear
    
    //-----------------------------------------------------------------------------
    // MARK: - @IBOutlets
    //-----------------------------------------------------------------------------
    
    @IBOutlet private weak var stretchedView: UIView?
    @IBOutlet private var fadeViews: [UIView]?
    
    //-----------------------------------------------------------------------------
    // MARK: - Private properties
    //-----------------------------------------------------------------------------
    
    private var resizeType: ResizeType = .none
    private var _stretchedView: UIView?
    private var _fadeViews = NSHashTable<UIView>(options: [.weakMemory])
    private var isSetupDone = false
    
    private var navigationControllerView: UIView? {
        return _viewController?.navigationController?.view
    }
    
    private var navigationBar: UINavigationBar? {
        return _viewController?.navigationController?.navigationBar
    }
    
    private lazy var navigationBarBackgroundView: UIView = {
        let navigationBarBackgroundView = UIView()
        navigationBarBackgroundView.isUserInteractionEnabled = false
        navigationBarBackgroundView.backgroundColor = navigationBackgroundColor
        navigationBarBackgroundView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)
        navigationBarBackgroundView.autoresizingMask = [.flexibleWidth]
        
        return navigationBarBackgroundView
    }()
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization and Setup
    //-----------------------------------------------------------------------------
    
    deinit {
        navigationBarBackgroundView.removeFromSuperview()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        if stretchedView != nil {
            // Setup from storybord flow
            setup()
        }
    }
    
    private func setup() {
        guard !isSetupDone else {
            print("StretchScrollView: Setup shouldn't be called twice")
            return
        }
        
        isSetupDone = true
        setupProperties()
        setupNotifications()
        setupNavigationBar()
        detectResizeType()
        configure()
    }
    
    private func setupProperties() {
        // Decreased button touch delay configuration
        delaysContentTouches = false
        
        // Should bounce even if contentSize is not enough
        alwaysBounceVertical = true
        
        delegate = self
        
        if let fadeViews = fadeViews {
            fadeViews.forEach({ _fadeViews.add($0) })
            self.fadeViews = nil
        }
        
        if let stretchedView = stretchedView {
            _stretchedView = stretchedView
            self.stretchedView = nil
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onWillMoveToParentViewController(_:)), name: .UIViewControllerWillMoveToParentViewController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onViewWillAppear(_:)), name: .UIViewControllerViewWillAppear, object: _viewController)
        NotificationCenter.default.addObserver(self, selector: #selector(onViewWillDisappear(_:)), name: .UIViewControllerViewWillDisappear, object: _viewController)
    }
    
    private func setupNavigationBar() {
        if manageNavigationBarTransparency {
            saveTransparencyState(replace: false)
            makeTransparent()
            _viewController?.automaticallyAdjustsScrollViewInsets = false
            
            if #available(iOS 11.0, *) { contentInsetAdjustmentBehavior = .never }
        }
        
        // Stretch scroll view conflicts with navigation bar stretch. Force disable it.
        if #available(iOS 11.0, *) { _viewController?.navigationItem.largeTitleDisplayMode = .never }
        
        configureNavigationBarBackgroundView()
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Configuration
    //-----------------------------------------------------------------------------
    
    private func configure() {
        configureStretchedView()
        configureVisibility()
    }
    
    private func configureStretchedView() {
        switch resizeType {
        case .none: break
            
        case .topAndHeight(let topConstraint, let heightConstraint, let defaultHeight):
            let compensatedContentOffsetY: CGFloat
            if #available(iOS 11.0, *) { compensatedContentOffsetY = contentOffset.y + adjustedContentInset.top }
            else { compensatedContentOffsetY = contentOffset.y + contentInset.top }
            
            topConstraint.constant = min(0, compensatedContentOffsetY)
            heightConstraint.constant = max(defaultHeight, defaultHeight - compensatedContentOffsetY)
            
        case .topAndSides(let topConstraint, let leftConstraint, let rightConstraint, let aspectRatio):
            let compensatedContentOffsetY: CGFloat
            if #available(iOS 11.0, *) { compensatedContentOffsetY = contentOffset.y + adjustedContentInset.top }
            else { compensatedContentOffsetY = contentOffset.y + contentInset.top }
            
            let newTopConstant = min(0, compensatedContentOffsetY)
            let newSidesConstant = newTopConstant * aspectRatio / 2
            topConstraint.constant = newTopConstant
            leftConstraint.constant = newSidesConstant
            rightConstraint.constant = newSidesConstant
        }
    }
    
    private func configureVisibility() {
        configureNavigationBarBackgroundView()
        
        let compensatedContentOffsetY: CGFloat
        if #available(iOS 11.0, *) { compensatedContentOffsetY = contentOffset.y + adjustedContentInset.top }
        else { compensatedContentOffsetY = contentOffset.y + contentInset.top }
        
        // Fade views and navigation bar
        var newAlpha = (FadeOutOffset + compensatedContentOffsetY) / FadeOutOffset
        newAlpha = max(0, newAlpha)
        newAlpha = min(1, newAlpha)
        _fadeViews.allObjects.forEach { $0.alpha = newAlpha }
        
        // Navigation bar alpha won't be changed if content inset top is not zero or navigation bar is not translucent.
        let shouldChangeNavigationBarAlpha: Bool
        if #available(iOS 11.0, *) { shouldChangeNavigationBarAlpha = adjustedContentInset.top == 0 && navigationBar?.isTranslucent == true }
        else { shouldChangeNavigationBarAlpha = contentInset.top == 0 && navigationBar?.isTranslucent == true }
        
        if shouldChangeNavigationBarAlpha {
            navigationBar?.subviews.forEach({ $0.alpha = newAlpha })
        }
        
        // Navigation bar background alpha
        let fadeInFinishDistance = NavigationFadeInFinishOffset
        let startFadeInDistance = min(fadeInFinishDistance, 0)
        let distance = fadeInFinishDistance - startFadeInDistance
        var backgroundNewAlpha = (startFadeInDistance + compensatedContentOffsetY) / distance
        backgroundNewAlpha = max(0, backgroundNewAlpha)
        backgroundNewAlpha = min(1, backgroundNewAlpha)
        navigationBarBackgroundView.alpha = backgroundNewAlpha * newAlpha
    }
    
    private func configureNavigationBarBackgroundView() {
        // Assure `navigationBarBackgroundView` below navigation bar
        if let navigationBar = navigationBar {
            navigationControllerView?.insertSubview(navigationBarBackgroundView, belowSubview: navigationBar)
        }
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - UIView Methods
    //-----------------------------------------------------------------------------
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if let navigationBar = navigationBar {
            navigationBarBackgroundView.frame = CGRect(x: 0, y: 0, width: navigationBar.bounds.width, height: navigationBar.frame.maxY)
        }
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - UIScrollView Methods
    //-----------------------------------------------------------------------------
    
    // Decreased button touch delay configuration
    override open func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Public Methods
    //-----------------------------------------------------------------------------
    
    /// Sets stretched view. Also performs all needed setup.
    /// Be sure to call this one only if you have to setup stretched view from code.
    /// Should be called only once and only after all setup for view hierarchy, constraints and VCs composition is done.
    public func setStretchedView(_ view: UIView) {
        guard _stretchedView == nil && stretchedView == nil else {
            print("Stretched view can't be exchanged when it previously was set")
            return
        }
        
        // Setup from code flow
        _stretchedView = view
        setup()
    }
    
    /// Adds views to fade when scrolling to bottom. Safe to call at any time.
    public func addFadeViews(_ views: [UIView]) {
        views.forEach { _fadeViews.add($0) }
        configure()
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Private methods - Notifications
    //-----------------------------------------------------------------------------
    
    @objc private func onWillMoveToParentViewController(_ notification: Notification) {
        // iOS bug, must configure navigation bar future state in willMove(toParentViewController:) method of popping view controller
        guard let viewController = notification.object as? UIViewController else { return }
        
        // Moving from parent
        guard notification.userInfo?["parent"] == nil else { return }
        
        if viewController._previousViewController == self._viewController {
            // Popping to our controller
            if manageNavigationBarTransparency {
                makeTransparent()
            }
        } else if viewController == self._viewController {
            // Popping our controller
            navigationBarBackgroundView.alpha = 0
            
            if manageNavigationBarTransparency {
                restoreTransparencyState()
            }
        }
    }
    
    @objc private func onViewWillAppear(_ notification: Notification) {
        if manageNavigationBarTransparency {
            saveTransparencyState(replace: false)
            makeTransparent()
        }
        
        configureVisibility()
    }
    
    @objc private func onViewWillDisappear(_ notification: Notification) {
        navigationBarBackgroundView.alpha = 0
        
        if manageNavigationBarTransparency {
            restoreTransparencyState()
        }
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Transparency State
    //-----------------------------------------------------------------------------
    
    private struct TransparencyState {
        let isTranslucent: Bool
        let backgroundImage: UIImage?
        let shadowImage: UIImage?
    }
    
    private var transparencyState: TransparencyState?
    
    private func saveTransparencyState(replace: Bool) {
        guard replace || transparencyState == nil, let navigationBar = navigationBar else { return }
        
        transparencyState = TransparencyState(isTranslucent: navigationBar.isTranslucent, backgroundImage: navigationBar.backgroundImage(for: .default), shadowImage: navigationBar.shadowImage)
    }
    
    private func restoreTransparencyState() {
        guard let transparencyState = transparencyState else { return }
        
        navigationBar?.isTranslucent = transparencyState.isTranslucent
        navigationBar?.setBackgroundImage(transparencyState.backgroundImage, for: .default)
        navigationBar?.shadowImage = transparencyState.shadowImage
    }
    
    private func makeTransparent() {
        navigationBar?.isTranslucent = true
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
    }
    
    // ******************************* MARK: - Private Methods
    
    private func detectResizeType() {
        guard resizeType.isNone else { return }
        guard let stretchedView = _stretchedView else { return }
        guard let superview = stretchedView.superview else { return }
        
        var topConstraint: NSLayoutConstraint?
        var leadingConstraint: NSLayoutConstraint?
        var trailingConstraint: NSLayoutConstraint?
        var heightConstraint: NSLayoutConstraint?
        var defaultHeight: CGFloat?
        
        for constraint in stretchedView.constraints {
            if (constraint.firstItem === stretchedView && constraint.firstAttribute == .height) {
                heightConstraint = constraint
                defaultHeight = constraint.constant
                break
            }
        }
        
        for constraint in superview.constraints {
            if (constraint.firstItem === stretchedView && constraint.secondItem === superview && constraint.firstAttribute == .top) ||
                (constraint.secondItem === stretchedView && constraint.firstItem === superview && constraint.secondAttribute == .top) {
                
                topConstraint = constraint
            }
            
            if (constraint.firstItem === stretchedView && constraint.secondItem === superview && constraint.firstAttribute == .leading) ||
                (constraint.secondItem === stretchedView && constraint.firstItem === superview && constraint.secondAttribute == .leading) {
                
                leadingConstraint = constraint
            }
            
            if (constraint.firstItem === stretchedView && constraint.secondItem === superview && constraint.firstAttribute == .trailing) ||
                (constraint.secondItem === stretchedView && constraint.firstItem === superview && constraint.secondAttribute == .trailing) {
                
                trailingConstraint = constraint
            }
        }
        
        if let topConstraint = topConstraint, let heightConstraint = heightConstraint, let defaultHeight = defaultHeight {
            resizeType = .topAndHeight(topConstraint: topConstraint, heightConstraint: heightConstraint, defaultHeight: defaultHeight)
        } else if let topConstraint = topConstraint, let leadingConstraint = leadingConstraint, let trailingConstraint = trailingConstraint {
            let aspectRatio: CGFloat = stretchedView.bounds.width / stretchedView.bounds.height
            resizeType = .topAndSides(topConstraint: topConstraint, leftConstraint: leadingConstraint, rightConstraint: trailingConstraint, aspectRatio: aspectRatio)
        } else {
            print("StretchScrollView: Unable to detect resize type")
        }
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
