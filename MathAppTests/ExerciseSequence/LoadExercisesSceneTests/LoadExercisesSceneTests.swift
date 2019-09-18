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
        let fakeDelegate = FakeLoadExercisesViewModelDelegate()
        let mockExercisesStore = FakeExercisesStore()
        let viewModel = LoadExercisesViewModel(delegate: fakeDelegate, exercisesStore: mockExercisesStore)
        let vc = LoadExercisesViewController(viewModel: viewModel)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(mockExercisesStore.updateExercises_callCount, 1)
    }
    
    func test_onExercisesLoaded_requestsNextScene() {
        let mockDelegate = FakeLoadExercisesViewModelDelegate()
        let stubExercisesStore = FakeExercisesStore()
        let viewModel = LoadExercisesViewModel(delegate: mockDelegate, exercisesStore: stubExercisesStore)
        let vc = LoadExercisesViewController(viewModel: viewModel)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(mockDelegate.next_callCount, 1)
    }
    
}
