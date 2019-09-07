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
        let viewModel = InfoViewModelImpl(delegate: mockDelegate, concept: Concept.constantRule)
        let vc = InfoViewController(viewModel: viewModel)
        
        vc.loadViewIfNeeded()
        vc.quitButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.quit_callCount, 1)
    }
    
    func test_contentView_firstViewIsTitleLabel() {
        let stubData = Concept.constantRule
        let viewModel = InfoViewModelImpl(delegate: FakeInfoViewModelDelegate(), concept: stubData)
        let vc = InfoViewController(viewModel: viewModel)
        
        vc.loadViewIfNeeded()
        
        XCTAssert(vc.scrollView.subviews.count >= 4)
        XCTAssert(vc.scrollView.subviews[3] is UILabel)
        XCTAssertEqual((vc.scrollView.subviews[3] as? UILabel)?.text, "Constant Rule")
    }

}
