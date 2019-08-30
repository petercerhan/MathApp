//
//  ExerciseCoordinatorTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 8/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

class ExerciseCoordinatorTests: XCTestCase {
    
    func test_start_shouldShowExerciseScene() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = ExerciseCoordinator(compositionRoot: CompositionRoot(), containerVC: mockContainerVC)
        
        coordinator.start()
        
        mockContainerVC.verifyDidShow(viewControllerType: ExerciseViewController.self)
    }
    
    func test_exerciseSceneRequestsNext_shouldShowNextExercise() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = ExerciseCoordinator(compositionRoot: CompositionRoot(), containerVC: mockContainerVC)

        coordinator.start()
        coordinator.next(TestExerciseViewModel())
        
        XCTAssertEqual(mockContainerVC.show_callCount, 2)
        mockContainerVC.verifyDidShow(viewControllerType: ExerciseViewController.self)
    }
    
}

class TestExerciseViewModel: ExerciseViewModelImpl {
    init() {
        super.init(delegate: FakeExerciseViewModelDelegate(), exercise: Exercise.exercise1, choiceConfiguration: ExerciseChoiceConfiguration.buildStub())
    }
}
