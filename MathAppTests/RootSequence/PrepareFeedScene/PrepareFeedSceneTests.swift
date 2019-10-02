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
    
    func test_onLoad_requestsNewFeedPackage() {
        let mockFeedPackageStore = FakeFeedPackageStore()
        let vm = PrepareFeedViewModel(feedPackageStore: mockFeedPackageStore)
        let vc = PrepareFeedViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(mockFeedPackageStore.updateFeedPackage_callCount, 1)
    }
    
    
    
    
    
    
}
