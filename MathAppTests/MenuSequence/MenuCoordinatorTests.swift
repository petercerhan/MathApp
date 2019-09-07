//
//  MenuCoordinatorTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

class MenuCoordinatorTests: XCTestCase {
    
    func test_start_shouldShowMenuScene() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = MenuCoordinator(delegate: FakeMenuCoordinatorDelegate(), containerVC: mockContainerVC, compositionRoot: CompositionRoot())
        
        coordinator.start()
        
        mockContainerVC.verifyDidShow(viewControllerType: MenuViewController.self)
    }
    
    func test_containerRequestsQuit_shouldRequestToQuit() {
        let mockDelegate = FakeMenuCoordinatorDelegate()
        let coordinator = MenuCoordinator(delegate: mockDelegate, containerVC: FakeContainerViewController(), compositionRoot: CompositionRoot())
        
        coordinator.start()
        coordinator.quit(TestQuitableContainerViewModel())
        
        XCTAssertEqual(mockDelegate.quit_callCount, 1)
    }
    
}

class TestQuitableContainerViewModel: QuitableContainerViewModelImpl {
    init() {
        super.init(delegate: FakeQuitableWorldViewModelDelegate())
    }
}
