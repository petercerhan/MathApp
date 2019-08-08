//
//  HomeSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 8/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class HomeSceneTests: XCTestCase {
    
    func test_UIComponents_connected() {
        let vc = HomeViewController()
        
        vc.loadViewIfNeeded()
        
        XCTAssertNotNil(vc.questionLabel)
        XCTAssertNotNil(vc.answer1Button)
        XCTAssertNotNil(vc.answer2Button)
        XCTAssertNotNil(vc.answer3Button)
    }
    
}
