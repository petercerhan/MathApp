//
//  LoadExercisesSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class LoadExercisesTests: XCTestCase {
    
    func test_onSetup_requestsNewExercises() {
        let mockExercisesStore = FakeExercisesStore()
        let viewModel = LoadExercisesViewModel(exercisesStore: mockExercisesStore)
        let vc = LoadExercisesViewController(viewModel: viewModel)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(mockExercisesStore.setStubExercises_callCount, 1)
    }
    
}
