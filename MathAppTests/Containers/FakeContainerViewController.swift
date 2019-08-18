//
//  FakeContainerViewController.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 8/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

class FakeContainerViewController: ContainerViewController {
    
    var show_callCount = 0
    var show_viewController = [UIViewController]()
    
    override func show(viewController newViewController: UIViewController, animation: TransitionAnimation) {
        show_callCount += 1
        show_viewController.append(newViewController)
    }
    
    func verifyDidShow<T>(viewControllerType: T.Type, file: StaticString = #file, line: UInt = #line) {
        XCTAssert(show_callCount > 0, file: file, line: line)
        if !(show_viewController.last is T) {
            XCTFail("Displayed View Controller type does not match", file: file, line: line)
        }
    }
    
    var dismissModal_callCount = 0
    
    override func dismissModal(animation: TransitionAnimation = .uncoverDown) {
        dismissModal_callCount += 1
    }
    
}



