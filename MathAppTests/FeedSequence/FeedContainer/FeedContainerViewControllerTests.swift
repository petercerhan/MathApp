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
    }
    
    func test_menuPressed_requestsMenu() {
        let mockDelegate = FakeFeedContainerViewModelDelegate()
        let vc = composeSUT(fakeDelegate: mockDelegate)
        
        vc.loadViewIfNeeded()
        vc.menuButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.menu_callCount, 1)
    }
    
    func test_progressState3of5_shouldShow60PercentProgress() {
        let mockResultsStore = FakeResultsStore()
        mockResultsStore.progressState = Observable.just(ProgressState(required: 5, correct: 3))
        let vc = composeSUT(fakeStore: mockResultsStore)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(roundToTwoDigits(vc.progressWidth.multiplier), 0.60)
    }
    
    func test_progressState5of5_shouldShow0PercentProgress() {
        let mockResultsStore = FakeResultsStore()
        mockResultsStore.progressState = Observable.just(ProgressState(required: 5, correct: 5))
        let vc = composeSUT(fakeStore: mockResultsStore)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(roundToTwoDigits(vc.progressWidth.multiplier), 1.0)
    }
    
    private func roundToTwoDigits(_ number: CGFloat) -> Double {
        print("round number \(number)")
        
        return round(Double(number) * 100) / 100
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeDelegate: FakeFeedContainerViewModelDelegate? = nil, fakeStore: ResultsStore? = nil) -> FeedContainerViewController {
        let delegate = fakeDelegate ?? FakeFeedContainerViewModelDelegate()
        let resultsStore = fakeStore ?? FakeResultsStore()
        let vm = FeedContainerViewModel(delegate: delegate, resultsStore: resultsStore)
        return FeedContainerViewController(viewModel: vm, resultsStore: resultsStore)
    }
    
    func stubStore_oneCorrect() -> ResultsStore {
        let stubStore = FakeResultsStore()
        stubStore.points = Observable.just(1)
        return stubStore
    }
    
}
