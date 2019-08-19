//
//  RootCoordinatorTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 8/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class RootCoordinatorTests: XCTestCase {
    
    func test_start_shouldShowExerciseSequence() {
        let fakeContainer = FakeContainerViewController()
        let coordinator = RootCoordinator(compositionRoot: CompositionRoot(), containerVC: fakeContainer)
        
        coordinator.start()
        
        fakeContainer.verifyDidShow(viewControllerType: ContainerViewController.self)
        XCTAssert(coordinator.childCoordinator is ExerciseCoordinator)
    }
    
}
