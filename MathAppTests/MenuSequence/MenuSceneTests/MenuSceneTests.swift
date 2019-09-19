//
//  MenuSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

class MenuSceneTests: XCTestCase {
    
    func test_conceptMapPressed_shouldRequestConceptMap() {
        let mockDelegate = FakeMenuViewModelDelegate()
        let vm = MenuViewModel(delegate: mockDelegate)
        let vc = MenuViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        vc.conceptMapButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.conceptMap_callCount, 1)
    }
    
    func test_resetDB_shouldRequestDBReset() {
        
        
        
        
        
    }
    
}
