//
//  InfoSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

class InfoSceneTests: XCTestCase {
    
    func test_quitButton_requestsToQuit() {
        let mockDelegate = FakeInfoViewModelDelegate()
        let viewModel = InfoViewModel(delegate: mockDelegate)
        let vc = InfoViewController(viewModel: viewModel)
        
        vc.loadViewIfNeeded()
        vc.quitButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.quit_callCount, 1)
    }

}
