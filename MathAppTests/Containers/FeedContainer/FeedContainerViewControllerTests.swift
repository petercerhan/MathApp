//
//  FeedContainerViewControllerTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import RxSwift
import XCTest
@testable import MathApp

class FeedContainerViewControllerTests: XCTestCase {
    
    func test_outlets_shouldBeConnected() {
        let resultsStore = FakeResultsStore()
        let vm = FeedContainerViewModel(resultsStore: resultsStore)
        let vc = FeedContainerViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        
        XCTAssertNotNil(vc.menuButton)
        XCTAssertNotNil(vc.pointsLabel)
    }
    
    func test_correctDisplay_1CorrectAnswer_shows1Correct() {
        let stubStore = FakeResultsStore()
        stubStore.correct = Observable.just(1)
        let vm = FeedContainerViewModel(resultsStore: stubStore)

        let vc = FeedContainerViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.pointsLabel.text, "1")
    }
    
}
