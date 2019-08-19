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
    
}
