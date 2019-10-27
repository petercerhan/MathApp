//
//  ExerciseCoordinatorTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 8/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
import RxSwift
@testable import MathApp

class FeedCoordinatorTests: XCTestCase {
    
    func test_start_learningStepLoaded_shouldSetLearningStep() {
        let mockResultsStore = FakeResultsStore()
        let coordinator = composeSUT(fakeResultsStore: mockResultsStore)
        
        coordinator.start()
        
        XCTAssertEqual(mockResultsStore.setLearningStep_callCount, 1)
    }
    
    func test_start_conceptIntroLearningStep_shouldShowConceptIntro() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: conceptIntroLS1)
        
        coordinator.start()
        
        mockContainerVC.verifyDidShow(viewControllerType: ConceptIntroViewController.self)
    }
    
    func test_conceptIntroLearningStep_shouldRefreshExercises() {
        let mockExerciseStore = FakeFeedExercisesStore()
        let coordinator = composeSUT(fakeExerciseStore: mockExerciseStore,
                                     stubLearningStep: conceptIntroLS1,
                                     stubExercises: [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3])
        
        coordinator.start()
        
        XCTAssertEqual(mockExerciseStore.refresh_callCount, 1)
    }
    
    func test_conceptIntroRequestsNext_shouldShowExerciseScene() {
        let stubExercises = [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: conceptIntroLS1, stubExercises: stubExercises)
        
        coordinator.start()
        coordinator.next(TestConceptIntroViewModel())
        
        mockContainerVC.verifyDidShow(viewControllerType: ExerciseViewController.self)
    }
    
    func test_exerciseRequestsNext_progressStateNotComplete_shouldShowExerciseScene() {
        let stubProgressState = ProgressState(required: 2, correct: 5)
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubProgressState: stubProgressState)
        
        coordinator.start()
        coordinator.next(TestConceptIntroViewModel())
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        XCTAssertEqual(mockContainerVC.show_callCount, 3)
        mockContainerVC.show_verifyPrior(viewControllerType: ExerciseViewController.self)
        mockContainerVC.verifyDidShow(viewControllerType: ExerciseViewController.self)
    }
    
    func test_exerciseRequestsNext_progressStateComplete_conceptIntroLS1_shouldShowLevelUpScene() {
        let stubProgressState = ProgressState(required: 5, correct: 5)
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubProgressState: stubProgressState)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        guard let levelUpVC = mockContainerVC.show_viewController.last as? LevelUpViewController else {
            XCTFail("Level up vc not displayed")
            return
        }
        levelUpVC.loadViewIfNeeded()
        XCTAssertEqual(levelUpVC.levelUpLabel.text, "Level *0* to level *1*")
        XCTAssertEqual(levelUpVC.conceptLabel.text, "Stub rule")
    }
    
    func test_exerciseRequestsNext_progressStateComplete_conceptIntroLS1_shouldUpdateUserConceptStrength() {
        let stubProgressState = ProgressState(required: 5, correct: 5)
        let mockUserConceptEDS = FakeUserConceptExternalDataService()
        let coordinator = composeSUT(stubProgressState: stubProgressState, fakeUserConceptEDS: mockUserConceptEDS)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        XCTAssertEqual(mockUserConceptEDS.update_callCount, 1)
        XCTAssertEqual(mockUserConceptEDS.update_id.first, 1)
        XCTAssertEqual(mockUserConceptEDS.update_fields.first?["strength"], "1")
    }
    
    func test_levelUp_shouldGetNextLearningStep() {
        let mockLearningStepStore = FakeLearningStepStore()
        let stubProgressState = ProgressState(required: 5, correct: 5)
        let coordinator = composeSUT(fakeLearningStepStore: mockLearningStepStore, stubProgressState: stubProgressState)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        XCTAssertEqual(mockLearningStepStore.next_callCount, 1)
    }
    
    func test_levelUpRequestsNext_conceptIntroLearningStep_shouldShowConceptIntro() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: conceptIntroLS1)
        
        coordinator.start()
        coordinator.next(TestLevelUpViewModel())
        
        XCTAssertEqual(mockContainerVC.show_callCount, 2)
        mockContainerVC.verifyDidShow(viewControllerType: ConceptIntroViewController.self)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeContainerViewController: ContainerViewController? = nil,
                    fakeLearningStepStore: FakeLearningStepStore? = nil,
                    fakeExerciseStore: FakeFeedExercisesStore? = nil,
                    fakeResultsStore: FakeResultsStore? = nil,
                    stubLearningStep: LearningStep? = nil,
                    stubExercises: [Exercise]? = nil,
                    stubProgressState: ProgressState? = nil,
                    fakeUserConceptEDS: FakeUserConceptExternalDataService? = nil) -> FeedCoordinator {
        
        let containerVC = fakeContainerViewController ?? FakeContainerViewController()
        
        let learningStepStore = fakeLearningStepStore ?? FakeLearningStepStore()
        if let stubLearningStep = stubLearningStep {
            learningStepStore.learningStep = Observable.just(.loaded(stubLearningStep))
        } else {
            learningStepStore.learningStep = Observable.just(.loaded(conceptIntroLS1))
        }
        
        let exercisesStore = fakeExerciseStore ?? FakeFeedExercisesStore()
        if let stubExercises = stubExercises {
            exercisesStore.exercises = Observable.just(.loaded(stubExercises))
        } else {
            exercisesStore.exercises = Observable.just(.loaded([Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]))
        }
        
        let resultsStore = fakeResultsStore ?? FakeResultsStore()
        resultsStore.learningStep = Observable.just(stubLearningStep ?? conceptIntroLS1)
        if let progressState = stubProgressState {
            resultsStore.progressState = Observable.just(progressState)
        }
        
        let userConceptEDS = fakeUserConceptEDS ?? FakeUserConceptExternalDataService()
        
        return FeedCoordinator(compositionRoot: CompositionRoot(),
                                   containerVC: containerVC,
                                   randomizationService: RandomizationServiceImpl(),
                                   resultsStore: resultsStore,
                                   learningStepStore: learningStepStore,
                                   exercisesStore: exercisesStore,
                                   userConceptEDS: userConceptEDS)
    }
    
    //MARK: - Stubs
    
    var conceptIntroLS1: ConceptIntroLearningStep = ConceptIntroLearningStep.createWithConceptID(conceptID: 1)
    
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
        super.init(delegate: FakeLoadExercisesViewModelDelegate())
    }
}

class TestConceptIntroViewModel: ConceptIntroViewModel {
    init() {
        super.init(delegate: FakeConceptIntroViewModelDelegate(), conceptIntro: ConceptIntroLearningStep.createStub())
    }
}

class TestLevelUpViewModel: LevelUpViewModel {
    init() {
        super.init(delegate: FakeLevelUpViewModelDelegate(), levelUpItem: LevelUpItem.constantRuleItem)
    }
}

class CompositionRoot_deadLoadScene: CompositionRoot {
    override func composeLoadExercisesScene(delegate: LoadExercisesViewModelDelegate) -> UIViewController {
        let vm = LoadExercisesViewModel(delegate: FakeLoadExercisesViewModelDelegate())
        return LoadExercisesViewController(viewModel: vm)
    }
}
