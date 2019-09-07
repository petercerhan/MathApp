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
        let vc = composeSUT(fakeDelegate: mockDelegate)
        
        vc.loadViewIfNeeded()
        vc.quitButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.quit_callCount, 1)
    }
    
    func test_contentView_firstViewIsTitleLabel() {
        let stubConcept = Concept.constantRule
        let vc = composeSUT(stubConcept: stubConcept)
        
        vc.loadViewIfNeeded()
        
        XCTAssert(vc.scrollView.subviews.count >= 4)
        XCTAssert(vc.scrollView.subviews[3] is UILabel)
        XCTAssertEqual((vc.scrollView.subviews[3] as? UILabel)?.text, stubConcept.name)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeDelegate: InfoViewModelDelegate? = nil, stubConcept: Concept? = nil) -> InfoViewController {
        let delegate = fakeDelegate ?? FakeInfoViewModelDelegate()
        let concept = stubConcept ?? Concept.constantRule
        let viewModel = InfoViewModelImpl(delegate: delegate, concept: concept)
        
        return InfoViewController(viewModel: viewModel)
    }

}
