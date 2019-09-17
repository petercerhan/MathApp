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
    
    func test_start_noExercisesLoaded_shouldShowLoadExercisesScene() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubData: [[Exercise]()])
        
        coordinator.start()
        
        mockContainerVC.verifyDidShow(viewControllerType: LoadExercisesViewController.self)
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
        coordinator.info(TestExerciseViewModel(), concept: Concept.constantRule)
        
        mockContainerVC.verifyDidPresentModal(viewControllerType: InfoViewController.self)
    }
    
    func test_infoSceneRequestsQuit_shouldDismissModal() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC)
        
        coordinator.start()
        coordinator.info(TestExerciseViewModel(), concept: Concept.constantRule)
        coordinator.quit(TestInfoViewModel())
        
        XCTAssertEqual(mockContainerVC.dismissModal_callCount, 1)
    }
    
    func test_containerRequestsMenu_shouldShowMenuContainer() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC)
        
        coordinator.start()
        coordinator.menu(TestFeedContainerViewModel())
        
        mockContainerVC.verifyDidPresentModal(viewControllerType: ContainerViewController.self)
    }
    
    func test_menuRequestsQuit_shouldDismissMenu() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC)
        
        coordinator.start()
        coordinator.quit(TestMenuCoordinator())
        
        XCTAssertEqual(mockContainerVC.dismissModal_callCount, 1)
    }
    
    func test_loadExercisesRequestsNext_shouldShowExerciseScene() {
        let mockContainerVC = FakeContainerViewController()
        //Load exercises view controller is automatically created by the coordinator & next is called due to the data structure
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubData: [[Exercise](), [Exercise.exercise1]])
        
        coordinator.start()
        
        let assertion = {
            mockContainerVC.verifyDidShow(viewControllerType: ExerciseViewController.self)
            for vc in mockContainerVC.show_viewController {
                print("ViewController type: \(type(of: vc))")
            }
        }
        delayedAssertion(assertion)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeContainerViewController: ContainerViewController, stubData: [[Exercise]]? = nil) -> ExerciseCoordinator {
        let exercisesStore = FakeExercisesStore()
        let data = stubData ?? [[Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]]
        exercisesStore.setStubExercises(data)
        
        return ExerciseCoordinator(compositionRoot: CompositionRoot(),
                                   containerVC: fakeContainerViewController,
                                   exerciseService: FakeExerciseService(),
                                   randomizationService: RandomizationServiceImpl(),
                                   resultsStore: FakeResultsStore(),
                                   exercisesStore: exercisesStore)
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

class TestInfoViewModel: InfoViewModelImpl {
    init() {
        super.init(delegate: FakeInfoViewModelDelegate(), concept: Concept.constantRule)
    }
}

class TestFeedContainerViewModel: FeedContainerViewModel {
    init() {
        super.init(delegate: FakeFeedContainerViewModelDelegate(), resultsStore: FakeResultsStore())
    }
}

class TestLoadExercisesViewModel: LoadExercisesViewModel {
    init() {
        super.init(delegate: FakeLoadExercisesViewModelDelegate(), exercisesStore: FakeExercisesStore())
    }
}
