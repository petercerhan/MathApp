//
//  TransitionAnimation.swift
//  MathApp
//
//  Created by Peter Cerhan on 8/10/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit

typealias TransitionAnimationExecutable = (_ containerViewController: UIViewController,
    _ priorViewController: UIViewController,
    _ newViewController: UIViewController,
    _ completion: @escaping () -> () ) -> ()

enum TransitionAnimation {
    case none
    case slideFromRight
    case slideFromLeft
    case slideFromBottom
    case slideFromTop
    case fadeIn
    case coverFromBottom
    case halfModal
    case partialModal(ratio: Double)
    
    //Assumes prior view controller is above new view controller in visual hierarchy
    case uncoverDown
    case uncoverFade
    
    case landscapeSlideNext
    case landscapeSlidePrevious
    
    var animation: TransitionAnimationExecutable {
        switch self {
            
        case .none:
            return { containerViewController, priorViewController, newViewController, completion in
                newViewController.view.alpha = 1
                completion()
            }
            
        case .slideFromRight:
            return { containerViewController, priorViewController, newViewController, completion in
                newViewController.view.center.x += containerViewController.view.frame.width
                newViewController.view.alpha = 1
                
                UIView.animate(withDuration: 0.5, animations: {
                    newViewController.view.center.x -= containerViewController.view.frame.width
                    priorViewController.view.center.x -= containerViewController.view.frame.width
                }, completion: { _ in
                    completion()
                })
            }
            
        case .slideFromLeft:
            return { containerViewController, priorViewController, newViewController, completion in
                newViewController.view.center.x -= containerViewController.view.frame.width
                newViewController.view.alpha = 1
                
                UIView.animate(withDuration: 0.5, animations: {
                    newViewController.view.center.x += containerViewController.view.frame.width
                    priorViewController.view.center.x += containerViewController.view.frame.width
                }, completion: { _ in
                    completion()
                })
            }
            
        case .slideFromBottom:
            return { containerViewController, priorViewController, newViewController, completion in
                newViewController.view.center.y += containerViewController.view.frame.height
                newViewController.view.alpha = 1
                
                UIView.animate(withDuration: 0.5, animations: {
                    newViewController.view.center.y -= containerViewController.view.frame.height
                    priorViewController.view.center.y -= containerViewController.view.frame.height
                }, completion: { _ in
                    completion()
                })
            }
            
        case .slideFromTop:
            return { containerViewController, priorViewController, newViewController, completion in
                newViewController.view.center.y -= containerViewController.view.frame.height
                newViewController.view.alpha = 1
                
                UIView.animate(withDuration: 0.5, animations: {
                    newViewController.view.center.y += containerViewController.view.frame.height
                    priorViewController.view.center.y += containerViewController.view.frame.height
                }, completion: { _ in
                    completion()
                })
            }
            
        case .fadeIn:
            return { containerViewController, priorViewController, newViewController, completion in
                UIView.animate(withDuration: 0.25,
                               delay: 0.0,
                               options: .curveEaseIn,
                               animations:
                    {
                        newViewController.view.alpha = 1
                }, completion:{
                    _ in
                    completion()
                })
            }
            
        case .coverFromBottom:
            return { containerViewController, priorViewController, newViewController, completion in
                newViewController.view.center.y += containerViewController.view.frame.height
                newViewController.view.alpha = 1
                
                UIView.animate(withDuration: 0.4, animations: {
                    newViewController.view.center.y -= containerViewController.view.frame.height
                }, completion: { _ in
                    completion()
                })
            }
            
        case .uncoverDown:
            return { containerViewController, priorViewController, newViewController, completion in
                newViewController.view.alpha = 1
                
                UIView.animate(withDuration: 0.4, animations: {
                    priorViewController.view.center.y += containerViewController.view.frame.height
                }, completion: { _ in
                    completion()
                })
            }
            
        case .uncoverFade:
            return { containerViewController, priorViewController, newViewController, completion in
                newViewController.view.alpha = 1
                
                UIView.animate(withDuration: 0.25, animations: {
                    priorViewController.view.alpha = 0
                }, completion: { _ in
                    completion()
                })
            }
            
        case .halfModal:
            return { containerViewController, priorViewController, newViewController, completion in
                
                let modalHeight = (0.55 * containerViewController.view.bounds.maxY)
                
                newViewController.view.frame = CGRect(x: containerViewController.view.bounds.minX,
                                                      y: containerViewController.view.bounds.minY,
                                                      width: containerViewController.view.bounds.maxX,
                                                      height: modalHeight)
                newViewController.view.center.y += containerViewController.view.frame.height
                newViewController.view.alpha = 1.0
                
                UIView.animate(withDuration: 0.3, animations: {
                    newViewController.view.center.y -= modalHeight
                }, completion: { _ in
                    completion()
                })
            }
            
        case .partialModal(let ratio):
            return { containerViewController, priorViewController, newViewController, completion in
                
                let modalHeight = (CGFloat(ratio) * containerViewController.view.bounds.maxY)
                
                newViewController.view.frame = CGRect(x: containerViewController.view.bounds.minX,
                                                      y: containerViewController.view.bounds.minY,
                                                      width: containerViewController.view.bounds.maxX,
                                                      height: modalHeight)
                newViewController.view.center.y += containerViewController.view.frame.height
                newViewController.view.alpha = 1.0
                
                UIView.animate(withDuration: 0.3, animations: {
                    newViewController.view.center.y -= modalHeight
                }, completion: { _ in
                    completion()
                })
            }
            
        case .landscapeSlideNext:
            return { containerViewController, priorViewController, newViewController, completion in
                newViewController.view.center.x += containerViewController.view.frame.height
                newViewController.view.alpha = 1
                
                UIView.animate(withDuration: 0.5, animations: {
                    newViewController.view.center.x -= containerViewController.view.frame.height
                    priorViewController.view.center.x -= containerViewController.view.frame.height
                }, completion: { _ in
                    completion()
                })
            }
            
        case .landscapeSlidePrevious:
            return { containerViewController, priorViewController, newViewController, completion in
                newViewController.view.center.x -= containerViewController.view.frame.height
                newViewController.view.alpha = 1
                
                UIView.animate(withDuration: 0.5, animations: {
                    newViewController.view.center.x += containerViewController.view.frame.height
                    priorViewController.view.center.x += containerViewController.view.frame.height
                }, completion: { _ in
                    completion()
                })
            }
        }
    }
    
}


