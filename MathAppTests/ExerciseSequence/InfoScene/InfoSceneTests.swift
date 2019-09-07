//
//  InfoSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
import iosMath
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
    
    func test_contentView_secondViewIsDescriptionLabel() {
        let stubConcept = Concept.constantRule
        let vc = composeSUT(stubConcept: stubConcept)
        
        vc.loadViewIfNeeded()
        
        guard vc.scrollView.subviews.count >= 5 else {
            XCTFail("Scrollview has too few subviews")
            return
        }
        XCTAssert(vc.scrollView.subviews[4] is UILabel)
        XCTAssertEqual((vc.scrollView.subviews[4] as? UILabel)?.text, stubConcept.description)
    }
    
    func test_contentView_fourthViewIsLatexExample() {
        let stubConcept = Concept.constantRule
        let vc = composeSUT(stubConcept: stubConcept)
        
        vc.loadViewIfNeeded()
        
        guard vc.scrollView.subviews.count >= 7 else {
            XCTFail("Scrollview has too few subviews")
            return
        }
        XCTAssert(vc.scrollView.subviews[6] is MTMathUILabel)
        XCTAssertEqual((vc.scrollView.subviews[6] as? MTMathUILabel)?.latex, stubConcept.example)
    }
    
    func test_contentView_sixthViewIsLatexExample() {
        let stubConcept = Concept.constantRule
        let vc = composeSUT(stubConcept: stubConcept)
        
        vc.loadViewIfNeeded()
        
        guard vc.scrollView.subviews.count >= 9 else {
            XCTFail("Scrollview has too few subviews")
            return
        }
        XCTAssert(vc.scrollView.subviews[8] is MTMathUILabel)
        XCTAssertEqual((vc.scrollView.subviews[8] as? MTMathUILabel)?.latex, stubConcept.rule)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeDelegate: InfoViewModelDelegate? = nil, stubConcept: Concept? = nil) -> InfoViewController {
        let delegate = fakeDelegate ?? FakeInfoViewModelDelegate()
        let concept = stubConcept ?? Concept.constantRule
        let viewModel = InfoViewModelImpl(delegate: delegate, concept: concept)
        
        return InfoViewController(viewModel: viewModel)
    }

}
