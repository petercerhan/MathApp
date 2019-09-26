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
        }
        delayedAssertion(assertion)
    }
    
    func test_threeExercises_showInOrderAndRequestRefreshAfterThirdLoaded() {
        let mockContainerVC = FakeContainerViewController()
        let stubData = [[Exercise.exercise1, Exercise.exercise4, Exercise.exercise7]]
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubData: stubData)
        
        coordinator.start()
        
        if mockContainerVC.show_viewController.count > 0,
            let vc = mockContainerVC.show_viewController[0] as? ExerciseViewController
        {
            vc.loadViewIfNeeded()
            XCTAssertEqual(vc.questionLatexLabel.latex, Exercise.exercise1.questionLatex)
        } else {
            XCTFail("ExerciseViewController not presented")
        }
    }
    
    func test_threeExercises_advanceToSecondExercise_shouldShowSecondExercise() {
        let mockContainerVC = FakeContainerViewController()
        let stubData = [[Exercise.exercise1, Exercise.exercise4, Exercise.exercise7]]
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubData: stubData)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel())
        
        if mockContainerVC.show_viewController.count > 1,
            let vc = mockContainerVC.show_viewController[1] as? ExerciseViewController
        {
            vc.loadViewIfNeeded()
            XCTAssertEqual(vc.questionLatexLabel.latex, Exercise.exercise4.questionLatex)
        } else {
            XCTFail("ExerciseViewController not presented")
        }
    }
    
    func test_threeExercises_advanceToThirdExercise_shouldShowThirdExercise() {
        let mockContainerVC = FakeContainerViewController()
        let stubData = [[Exercise.exercise1, Exercise.exercise4, Exercise.exercise7]]
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubData: stubData)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel())
        coordinator.next(TestExerciseViewModel())
        
        if mockContainerVC.show_viewController.count > 2,
            let vc = mockContainerVC.show_viewController[2] as? ExerciseViewController
        {
            vc.loadViewIfNeeded()
            XCTAssertEqual(vc.questionLatexLabel.latex, Exercise.exercise7.questionLatex)
        } else {
            XCTFail("ExerciseViewController not presented")
        }
    }
    
    func test_threeExercises_advanceToThirdExercise_shouldRequestNewExercises() {
        let mockExercisesStore = FakeExercisesStore()
        let stubData = [[Exercise.exercise1, Exercise.exercise4, Exercise.exercise7]]
        let coordinator = composeSUT(fakeExercisesStore: mockExercisesStore, stubData: stubData)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel())
        coordinator.next(TestExerciseViewModel())
        
        XCTAssertEqual(mockExercisesStore.updateExercises_callCount, 1)
    }
    
    func test_loadExercise_id1_shouldLoadExerciseID1FromDatabaseService() {
        
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeContainerViewController: ContainerViewController? = nil, fakeExercisesStore: FakeExercisesStore? = nil, stubData: [[Exercise]]? = nil) -> ExerciseCoordinator {
        let containerVC = fakeContainerViewController ?? FakeContainerViewController()
        let exercisesStore = fakeExercisesStore ?? FakeExercisesStore()
        let data = stubData ?? [[Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]]
        exercisesStore.setStubExercises(data)
        
        return ExerciseCoordinator(compositionRoot: CompositionRoot(),
                                   containerVC: containerVC,
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
