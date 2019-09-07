//
//  QuitableContainerViewControllerTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

class QuitableContainerViewControllerTests: XCTestCase {
    
    func test_outlets_shouldBeConnected() {
        let vm = FakeQuitableContainerViewModel()
        let vc = QuitableContainerViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        
        XCTAssertNotNil(vc.quitButton)
    }
    
    func test_quitButtonPress_requestsToQuit() {
        let mockViewModel = FakeQuitableContainerViewModel()
        let vc = QuitableContainerViewController(viewModel: mockViewModel)
        
        vc.loadViewIfNeeded()
        vc.quitButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockViewModel.dispatch_callCount, 1)
    }
    
    func test_quitButtonPress_shouldSendQuitRequestToDelegate() {
        let mockDelegate = FakeQuitableWorldViewModelDelegate()
        let vm = QuitableContainerViewModelImpl(delegate: mockDelegate)
        let vc = QuitableContainerViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        vc.quitButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.quit_callCount, 1)
    }
    
    func test_quitButtonPress_delegateSetThroughController_shouldSendQuitRequestToDelegate() {
        let mockDelegate = FakeQuitableWorldViewModelDelegate()
        let vm = QuitableContainerViewModelImpl(delegate: nil)
        let vc = QuitableContainerViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        vc.setDelegate(mockDelegate)
        vc.quitButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.quit_callCount, 1)
    }
    
}

class FakeQuitableWorldViewModelDelegate: QuitableContainerViewModelDelegate {
    var quit_callCount = 0
    func quit(_ quitableWorldViewModel: QuitableContainerViewModel) {
        quit_callCount += 1
    }
}
