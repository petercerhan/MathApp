//
//  FeedContainerViewControllerTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

class FeedContainerViewControllerTests: XCTestCase {
    
    func test_outlets_shouldBeConnected() {
        let vc = FeedContainerViewController()
        
        vc.loadViewIfNeeded()
        
        XCTAssertNotNil(vc.menuButton)
        XCTAssertNotNil(vc.pointsLabel)
    }
    
}
