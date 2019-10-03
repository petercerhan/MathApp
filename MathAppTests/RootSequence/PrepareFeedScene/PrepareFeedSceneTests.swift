//
//  PrepareFeedSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class PrepareFeedSceneTests: XCTestCase {
    
    func test_onLoad_shouldRequestNewFeedPackage() {
        let mockFeedPackageStore = FakeFeedPackageStore()
        let vm = PrepareFeedViewModel(delegate: FakePrepareFeedViewModelDelegate(), feedPackageStore: mockFeedPackageStore)
        let vc = PrepareFeedViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(mockFeedPackageStore.updateFeedPackage_callCount, 1)
    }
    
    func test_feedPackageLoaded_shouldRequestNextScene() {
        let mockDelegate = FakePrepareFeedViewModelDelegate()
        let stubFeedPackageStore = FakeFeedPackageStore()
        stubFeedPackageStore.setStubFeedPackage_doNotEmit(FeedPackage.exercisesPackage)
        let vm = PrepareFeedViewModel(delegate: mockDelegate, feedPackageStore: stubFeedPackageStore)
        let vc = PrepareFeedViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        
        let assertion = {
            XCTAssertEqual(mockDelegate.next_callCount, 1)
        }
        delayedAssertion(assertion)
    }
    
    
    
    
}
