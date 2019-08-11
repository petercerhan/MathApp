//
//  ContainerViewControllerTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 8/10/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class ContainerViewControllerTests: XCTestCase {
    
    func test_show_setsContentViewController() {
        let containerVC = ContainerViewController()
        
        containerVC.show(viewController: TestViewController(), animation: .none)
        
        XCTAssertTrue(containerVC.contentViewController is TestViewController)
    }
    
    func test_presentModal_setsContentVCAndBaseVC() {
        let containerVC = ContainerViewController()
        
        containerVC.show(viewController: TestViewController(), animation: .none)
        containerVC.presentModal(viewController: TestModalViewController(), animation: .none)
        
        XCTAssertTrue(containerVC.contentViewController is TestModalViewController)
        XCTAssertNotNil(containerVC.baseViewController)
        XCTAssertTrue(containerVC.baseViewController is TestViewController)
    }
    
    func test_dismissModal_noModalVCPresented_leavesContentVCInPlace() {
        let containerVC = ContainerViewController()
        
        containerVC.show(viewController: TestViewController(), animation: .none)
        containerVC.dismissModal(animation: .none)
        
        XCTAssertTrue(containerVC.contentViewController is TestViewController)
        XCTAssertNil(containerVC.baseViewController)
    }
    
    func test_dismissModal_modalVCPresented_restoresBaseVCAsContentVC() {
        let containerVC = ContainerViewController()
        
        containerVC.show(viewController: TestViewController(), animation: .none)
        containerVC.presentModal(viewController: TestModalViewController(), animation: .none)
        containerVC.dismissModal(animation: .none)
        
        XCTAssertTrue(containerVC.contentViewController is TestViewController)
        XCTAssertNil(containerVC.baseViewController)
    }
    
    func test_replaceBase_setsBaseVCWithModalUnchanged() {
        let containerVC = ContainerViewController()
        
        containerVC.show(viewController: TestViewController(), animation: .none)
        containerVC.presentModal(viewController: TestModalViewController(), animation: .none)
        containerVC.replaceBase(withViewController: SecondTestViewController())
        
        XCTAssertTrue(containerVC.contentViewController is TestModalViewController)
        XCTAssertTrue(containerVC.baseViewController is SecondTestViewController)
    }
    
    func test_isModallyPresentingProperty_noPresentation_isFalse() {
        let containerVC = ContainerViewController()
        
        containerVC.show(viewController: TestViewController(), animation: .none)
        
        XCTAssertFalse(containerVC.isModallyPresenting)
    }
    
    func test_isModallyPresentingProperty_activePresentation_isTrue() {
        let containerVC = ContainerViewController()
        
        containerVC.show(viewController: TestViewController(), animation: .none)
        containerVC.presentModal(viewController: TestModalViewController(), animation: .none)
        
        XCTAssertTrue(containerVC.isModallyPresenting)
    }
    
}


class TestViewController: UIViewController {
    
}

class TestModalViewController: UIViewController {
    
}

class SecondTestViewController: UIViewController {
    
}
