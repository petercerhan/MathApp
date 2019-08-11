//
//  ContainerViewController.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/10/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    private(set) var contentViewController = UIViewController()
    
    //"Presenting" view controller during modal presentations
    private(set) var baseViewController: UIViewController?
    
    var shouldHideStatusBar: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    var isModallyPresenting: Bool {
        return baseViewController != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentViewController.view)
    }
    
    var contentView: UIView {
        return view
    }
    
    func show(viewController newViewController: UIViewController, animation: TransitionAnimation) {
        let priorViewController = contentViewController
        contentViewController = newViewController
        addChild(newViewController)
        
        newViewController.view.frame = contentView.bounds
        newViewController.view.alpha = 0 //Default before animation
        contentView.addSubview(newViewController.view)
        
        priorViewController.willMove(toParent: nil)
        newViewController.didMove(toParent: self)
        
        animation.animation(self, priorViewController, newViewController) {
            priorViewController.view.removeFromSuperview()
            priorViewController.removeFromParent()
        }
    }
    
    func presentModal(viewController newViewController: UIViewController, animation: TransitionAnimation = .coverFromBottom) {
        let priorViewController = contentViewController
        contentViewController = newViewController
        addChild(newViewController)
        
        baseViewController = priorViewController
        
        newViewController.view.frame = contentView.bounds
        newViewController.view.alpha = 0 //Default before animation
        contentView.addSubview(newViewController.view)
        
        newViewController.didMove(toParent: self)
        
        animation.animation(self, priorViewController, newViewController) {
            /*no completion handler*/
        }
    }
    
    func dismissModal(animation: TransitionAnimation = .uncoverDown) {
        guard let newViewController = baseViewController else {
            return
        }
        
        let priorViewController = contentViewController
        contentViewController = newViewController
        
        priorViewController.willMove(toParent: nil)
        
        animation.animation(self, priorViewController, newViewController) { [weak self] in
            priorViewController.view.removeFromSuperview()
            priorViewController.removeFromParent()
            self?.baseViewController = nil
        }
        
    }
    
    func replaceBase(withViewController newViewController: UIViewController) {
        guard let priorViewController = baseViewController else {
            return
        }
        
        baseViewController = newViewController
        addChild(newViewController)
        
        newViewController.view.frame = contentView.bounds
        contentView.insertSubview(newViewController.view, belowSubview: contentViewController.view)
        
        newViewController.didMove(toParent: self)
        
        priorViewController.willMove(toParent: nil)
        priorViewController.view.removeFromSuperview()
        priorViewController.removeFromParent()
    }
    
}
