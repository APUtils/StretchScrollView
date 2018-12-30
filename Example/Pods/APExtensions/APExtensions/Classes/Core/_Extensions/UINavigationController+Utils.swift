//
//  UINavigationController+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 6/6/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


public extension UINavigationController {
    /// Root view controller
    public var rootViewController: UIViewController {
        return viewControllers.first!
    }
    
    /// Pushes view controller animated
    public func pushViewController(_ viewController: UIViewController) {
        pushViewController(viewController, animated: true)
    }
    
    /// Pops view controller animated
    public func popViewController() {
        popViewController(animated: true)
    }
}

// ******************************* MARK: - Completion

public extension UINavigationController {
    /// Pushes view controller with completion
    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        pushViewController(viewController, animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil, completion: { _ in completion?() })
        } else {
            completion?()
        }
    }
    
    /// Pops view controller with completion
    public func popViewController(animated: Bool, completion: (() -> Void)?) {
        popViewController(animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil, completion: { _ in completion?() })
        } else {
            completion?()
        }
    }
    
    /// Pops view controller if it present in navigation stack and all overlaying view controllers.
    /// Do nothing if view controller is not in navigation stack.
    public func pop(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if viewControllers.last == viewController {
            // Last controller in stack. Just dismiss it.
            popViewController(animated: animated, completion: completion)
        } else {
            // Not last controller in stack. Pop view controller together with overlaying controllers.
            guard let index = viewControllers.index(of: viewController) else {
                completion?()
                return
            }
            
            let newViewControllers = Array(viewControllers.prefix(upTo: index))
            setViewControllers(newViewControllers, animated: animated, completion: completion)
        }
    }
    
    /// Pops to root with completion
    public func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        popToRootViewController(animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil, completion: { _ in completion?() })
        } else {
            completion?()
        }
    }
    
    /// Replaces view controllers with completion
    public func setViewControllers(_ vcs: [UIViewController], animated: Bool, completion: (() -> Void)?) {
        setViewControllers(vcs, animated: animated)
        
        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil, completion: { _ in completion?() })
        } else {
            completion?()
        }
    }
    
    /// Replaces last view controller with completion
    public func replaceLast(_ vc: UIViewController, animated: Bool, completion: (() -> Void)?) {
        var vcs = viewControllers
        vcs.removeLast()
        vcs.append(vc)
        
        setViewControllers(vcs, animated: animated, completion: completion)
    }
}
