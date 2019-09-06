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
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC)
        
        coordinator.start()
        
        mockContainerVC.verifyDidShow(viewControllerType: ExerciseViewController.self)
    }
    
    func test_exerciseSceneRequestsNext_shouldShowNextExercise() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC)

        coordinator.start()
        coordinator.next(TestExerciseViewModel())
        
        XCTAssertEqual(mockContainerVC.show_callCount, 2)
        mockContainerVC.verifyDidShow(viewControllerType: ExerciseViewController.self)
    }
    
    func test_exerciseSceneRequestsInfo_shouldShowInfoScene() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC)
        
        coordinator.start()
        coordinator.info(TestExerciseViewModel())
        
        mockContainerVC.verifyDidPresentModal(viewControllerType: InfoViewController.self)
    }
    
    func test_infoSceneRequestsQuit_dismissesModal() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC)
        
        coordinator.start()
        coordinator.info(TestExerciseViewModel())
        coordinator.quit(TestInfoViewModel())
        
        XCTAssertEqual(mockContainerVC.dismissModal_callCount, 1)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeContainerViewController: ContainerViewController) -> ExerciseCoordinator {
        return ExerciseCoordinator(compositionRoot: CompositionRoot(),
                                   containerVC: fakeContainerViewController,
                                   exerciseService: FakeExerciseService(),
                                   randomizationService: RandomizationServiceImpl(),
                                   resultsStore: FakeResultsStore())
    }
    
}

class TestExerciseViewModel: ExerciseViewModelImpl {
    init() {
        super.init(delegate: FakeExerciseViewModelDelegate(),
                   resultsStore: FakeResultsStore(),
                   exercise: Exercise.exercise1,
                   choiceConfiguration: ExerciseChoiceConfiguration.buildStub())
    }
}

class TestInfoViewModel: InfoViewModel {
    init() {
        super.init(delegate: FakeInfoViewModelDelegate())
    }
}
