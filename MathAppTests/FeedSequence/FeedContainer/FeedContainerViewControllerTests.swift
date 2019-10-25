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
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        
        XCTAssertNotNil(vc.menuButton)
        XCTAssertNotNil(vc.pointsLabel)
    }
    
    func test_correctDisplay_1CorrectAnswer_shows1Correct() {
        let stubStore = stubStore_oneCorrect()
        let vc = composeSUT(fakeStore: stubStore)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.pointsLabel.text, "1")
    }
    
    func test_menuPressed_requestsMenu() {
        let mockDelegate = FakeFeedContainerViewModelDelegate()
        let vc = composeSUT(fakeDelegate: mockDelegate)
        
        vc.loadViewIfNeeded()
        vc.menuButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.menu_callCount, 1)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeDelegate: FakeFeedContainerViewModelDelegate? = nil, fakeStore: ResultsStore? = nil) -> FeedContainerViewController {
        let delegate = fakeDelegate ?? FakeFeedContainerViewModelDelegate()
        let resultsStore = fakeStore ?? FakeResultsStore()
        let vm = FeedContainerViewModel(delegate: delegate, resultsStore: resultsStore)
        return FeedContainerViewController(viewModel: vm)
    }
    
    func stubStore_oneCorrect() -> ResultsStore {
        let stubStore = FakeResultsStore()
        stubStore.points = Observable.just(1)
        return stubStore
    }
    
}
