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
    
    //MARK: - Concept Intro Learning Step
    
    func test_conceptIntroLearningStep_shouldSetResultBenchmarks() {
        let mockResultsStore = FakeResultsStore()
        let coordinator = composeSUT(fakeResultsStore: mockResultsStore, stubLearningStep: conceptIntroLS1)
        
        coordinator.start()
        
        XCTAssertEqual(mockResultsStore.setBenchmarks_callCount, 1)
        guard let benchmarks = mockResultsStore.setBenchmarks_benchmarks.first, let firstBenchmark = benchmarks.first else {
            XCTFail("benchmarks not set")
            return
        }
        XCTAssertEqual(firstBenchmark.conceptID, 1)
        XCTAssertEqual(firstBenchmark.correctAnswersRequired, 5)
        XCTAssertEqual(firstBenchmark.correctAnswersOutOf, 7)
    }
    
    func test_conceptIntroLearningStep_shouldRefreshExercises() {
        let mockExerciseStore = FakeFeedExercisesStore()
        let coordinator = composeSUT(fakeExerciseStore: mockExerciseStore,
                                     stubLearningStep: conceptIntroLS1,
                                     stubExercises: [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3])
        
        coordinator.start()
        
        XCTAssertEqual(mockExerciseStore.refresh_callCount, 1)
        XCTAssertEqual(mockExerciseStore.refresh_conceptIDs, [[1]])
    }
    
    func test_conceptIntroLearningStepConcept2_shouldRefreshExercises() {
        let mockExerciseStore = FakeFeedExercisesStore()
        let coordinator = composeSUT(fakeExerciseStore: mockExerciseStore,
                                     stubLearningStep: conceptIntroLS2,
                                     stubExercises: [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3])
        
        coordinator.start()
        
        XCTAssertEqual(mockExerciseStore.refresh_callCount, 1)
        XCTAssertEqual(mockExerciseStore.refresh_conceptIDs, [[2]])
    }
    
    func test_conceptIntroRequestsNext_shouldShowExerciseScene() {
        let stubExercises = [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: conceptIntroLS1, stubExercises: stubExercises)
        
        coordinator.start()
        coordinator.next(TestConceptIntroViewModel())
        
        mockContainerVC.verifyDidShow(viewControllerType: ExerciseViewController.self)
    }
    
    //MARK: - Practice Two Concepts Learning Step
    
    func test_practiceTwoConceptsLearningStep_shouldSetResultBenchmarks() {
        let mockResultsStore = FakeResultsStore()
        let coordinator = composeSUT(fakeResultsStore: mockResultsStore, stubLearningStep: practiceLS12)
        
        coordinator.start()
        
        XCTAssertEqual(mockResultsStore.setBenchmarks_callCount, 1)
        guard let benchmarks = mockResultsStore.setBenchmarks_benchmarks.first,
            benchmarks.count > 1
        else {
            XCTFail("benchmarks not set")
            return
        }
        XCTAssertEqual(benchmarks[0].conceptID, 1)
        XCTAssertEqual(benchmarks[0].correctAnswersRequired, 4)
        XCTAssertEqual(benchmarks[0].correctAnswersOutOf, 6)
        XCTAssertEqual(benchmarks[1].conceptID, 2)
        XCTAssertEqual(benchmarks[1].correctAnswersRequired, 4)
        XCTAssertEqual(benchmarks[1].correctAnswersOutOf, 6)
    }
    
    func test_practiceTwoConceptsLearningStep_12_shouldRefreshExercises() {
        let mockExerciseStore = FakeFeedExercisesStore()
        let coordinator = composeSUT(fakeExerciseStore: mockExerciseStore,
                                     stubLearningStep: practiceLS12)
        
        coordinator.start()
        
        XCTAssertEqual(mockExerciseStore.refresh_callCount, 1)
        XCTAssertEqual(mockExerciseStore.refresh_conceptIDs, [[1,2]])
    }
    
    func test_practiceTwoConceptsComplete_shouldShowDoubleLevelUpScene() {
        let mockContainer = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainer, stubLearningStep: practiceLS12, stubProgressState: ProgressState(required: 1, correct: 1))
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        guard let _ = mockContainer.show_viewController.last as? DoubleLevelUpViewController else {
            XCTFail("Double Level up vc not displayed")
            return
        }
    }
    
    //MARK: - Practice Intro Delegate
    
    func test_practiceIntroRequestsNext_shouldShowExerciseScene() {
        let stubExercises = [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: conceptIntroLS1, stubExercises: stubExercises)
        
        coordinator.start()
        coordinator.next(TestPracticeIntroViewModel())
        
        mockContainerVC.verifyDidShow(viewControllerType: ExerciseViewController.self)
    }
    
    //MARK: - Exercises
    
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
    
    func test_exerciseRequestsNext_exerciseQueueExhausted_shouldRefreshStore() {
        let mockExerciseStore = FakeFeedExercisesStore()
        let coordinator = composeSUT(fakeExerciseStore: mockExerciseStore, stubPracticeConcepts: [1,2], stubExercises: [Exercise.exercise1, Exercise.exercise2])
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        XCTAssertEqual(mockExerciseStore.refresh_callCount, 3)
        XCTAssertEqual(mockExerciseStore.refresh_conceptIDs, [[1],[1,2],[1,2]])
    }
    
    //After moving to first exercise scene, should load store exercises into queue and refresh store a second time
    func test_showExerciseScene_reloadExercises_shouldRefreshStore() {
        let mockExerciseStore = FakeFeedExercisesStore()
        let coordinator = composeSUT(fakeExerciseStore: mockExerciseStore, stubExercises: [Exercise.exercise1, Exercise.exercise2])
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        XCTAssertEqual(mockExerciseStore.refresh_callCount, 2)
    }
    
    //MARK: - Level Up
    
    func test_levelUp_shouldGetNextLearningStep() {
        let mockLearningStepStore = FakeLearningStepStore()
        let stubProgressState = ProgressState(required: 5, correct: 5)
        let coordinator = composeSUT(fakeLearningStepStore: mockLearningStepStore, stubProgressState: stubProgressState)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        XCTAssertEqual(mockLearningStepStore.next_callCount, 1)
    }
    
    func test_levelUp_shouldResetResultsStore() {
        let mockResultsStore = FakeResultsStore()
        let stubProgressState = ProgressState(required: 5, correct: 5)
        let coordinator = composeSUT(fakeResultsStore: mockResultsStore, stubProgressState: stubProgressState)

        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)

        XCTAssertEqual(mockResultsStore.reset_callCount, 1)
    }
    
    func test_levelUpRequestsNext_conceptIntroLearningStep_shouldShowConceptIntro() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: conceptIntroLS1)
        
        coordinator.start()
        coordinator.next(TestLevelUpViewModel())
        
        XCTAssertEqual(mockContainerVC.show_callCount, 2)
        mockContainerVC.verifyDidShow(viewControllerType: ConceptIntroViewController.self)
    }
    
    func test_levelUpRequestsNext_practiceTwoLearningStep_shouldShowPracticeIntro() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: practiceLS12)
        
        coordinator.start()
        coordinator.next(TestLevelUpViewModel())
        
        XCTAssertEqual(mockContainerVC.show_callCount, 2)
        mockContainerVC.verifyDidShow(viewControllerType: PracticeIntroViewController.self)
    }
    
    func test_levelUpRequestsNext_practiceTwoLearningStep_shouldRefreshExercises() {
        let mockExerciseStore = FakeFeedExercisesStore()
        let coordinator = composeSUT(fakeExerciseStore: mockExerciseStore,
                                     stubLearningStep: practiceLS12,
                                     stubExercises: [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3])
        
        coordinator.start()
        
        XCTAssertEqual(mockExerciseStore.refresh_callCount, 1)
    }
    
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeContainerViewController: ContainerViewController? = nil,
                    fakeLearningStepStore: FakeLearningStepStore? = nil,
                    fakeExerciseStore: FakeFeedExercisesStore? = nil,
                    fakeResultsStore: FakeResultsStore? = nil,
                    stubLearningStep: LearningStep? = nil,
                    stubPracticeConcepts: [Int]? = nil,
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
        if let stubPracticeConcepts = stubPracticeConcepts {
            resultsStore.practiceConcepts = Observable.just(stubPracticeConcepts)
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
    var conceptIntroLS2: ConceptIntroLearningStep = ConceptIntroLearningStep.createWithConceptID(conceptID: 2)
    
    var practiceLS12: PracticeTwoConceptsLearningStep = PracticeTwoConceptsLearningStep.createStub(id1: 1, id2: 2)
    
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

class TestPracticeIntroViewModel: PracticeIntroViewModel {
    init() {
        super.init(delegate: FakePracticeIntroViewModelDelegate())
    }
}

class CompositionRoot_deadLoadScene: CompositionRoot {
    override func composeLoadExercisesScene(delegate: LoadExercisesViewModelDelegate) -> UIViewController {
        let vm = LoadExercisesViewModel(delegate: FakeLoadExercisesViewModelDelegate())
        return LoadExercisesViewController(viewModel: vm)
    }
}
