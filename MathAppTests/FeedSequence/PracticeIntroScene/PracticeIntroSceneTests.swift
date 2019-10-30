//
//  PracticeIntroSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/29/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class PracticeIntroSceneTests: XCTestCase {
    
    func test_next_shouldRequestNext() {
        let mockDelegate = FakePracticeIntroViewModelDelegate()
        let vm = PracticeIntroViewModel(delegate: mockDelegate)
        let vc = PracticeIntroViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        vc.nextButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.next_callCount, 1)
    }
}
