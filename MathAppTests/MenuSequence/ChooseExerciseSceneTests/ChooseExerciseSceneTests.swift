//
//  ChooseExerciseSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/24/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class ChooseExerciseSceneTests: XCTestCase {
    
    func test_back_shouldRequestBack() {
        let mockDelegate = FakeChooseExerciseViewModelDelegate()
        let vm = ChooseExerciseViewModel(delegate: mockDelegate)
        let vc = ChooseExerciseViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        vc.backButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.back_callCount, 1)
    }
    
    
    
    
}
