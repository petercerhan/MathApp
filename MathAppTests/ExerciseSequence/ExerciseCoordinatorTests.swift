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
    
    func test_start_showsHomeScene() {
        let fakeContainerVC = FakeContainerViewController()
        let coordinator = ExerciseCoordinator(compositionRoot: CompositionRoot(), containerVC: fakeContainerVC)
        
        coordinator.start()
        
        fakeContainerVC.verifyDidShow(viewControllerType: HomeViewController.self)
    }
    
}
