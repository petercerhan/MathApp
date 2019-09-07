//
//  ConceptMapSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

class ConceptMapSceneTests: XCTestCase {
    
    func test_backPressed_shouldRequestBack() {
        let mockDelegate = FakeConceptMapViewModelDelegate()
        let vm = ConceptMapViewModel(delegate: mockDelegate)
        let vc = ConceptMapViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        vc.backButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.back_callCount, 1)
    }
    
}
