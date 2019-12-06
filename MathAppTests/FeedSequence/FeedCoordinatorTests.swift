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
    
    //MARK: - Concept Intro Learning Step
    
    func test_start_conceptIntroLearningStep_shouldShowConceptIntro() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: conceptIntroLS1)
        
        coordinator.start()
        
        mockContainerVC.verifyDidShow(viewControllerType: ConceptIntroViewController.self)
    }
    
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
    
    func test_conceptIntroLevelUp_shouldUpdateUserConceptStrength() {
        let mockUserConceptEDS = FakeUserConceptExternalDataService()
        let coordinator = composeSUT(stubLearningStep: conceptIntroLS1, stubProgressState: ProgressState(required: 5, correct: 5), fakeUserConceptEDS: mockUserConceptEDS)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        XCTAssertEqual(mockUserConceptEDS.update_callCount, 1)
        XCTAssertEqual(mockUserConceptEDS.update_id.first, 1)
        XCTAssertEqual(mockUserConceptEDS.update_fields.first?["strength"], "1")
    }
    
    func test_conceptIntroLevelUp_shouldRefreshLearningStep() {
        let mockLearningStepStore = FakeLearningStepStore()
        let coordinator = composeSUT(fakeLearningStepStore: mockLearningStepStore, stubLearningStep: conceptIntroLS1, stubProgressState: ProgressState(required: 5, correct: 5))
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        XCTAssertEqual(mockLearningStepStore.next_callCount, 1)
    }
    
    //MARK: - Practice One Concept Learning Step
    
    func test_nextLearningStep_practiceOneLearningStep_shouldShowPracticeIntro() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: practiceLS1)
        
        coordinator.start()
        
        XCTAssertEqual(mockContainerVC.show_callCount, 1)
        mockContainerVC.verifyDidShow(viewControllerType: PracticeIntroViewController.self)
    }
    
    func test_practiceOneConceptLearningStep_shouldSetResultBenchmarks() {
        let mockResultsStore = FakeResultsStore()
        let coordinator = composeSUT(fakeResultsStore: mockResultsStore, stubLearningStep: practiceLS1)

        coordinator.start()
        
        XCTAssertEqual(mockResultsStore.setBenchmarks_callCount, 1)
        guard let benchmarks = mockResultsStore.setBenchmarks_benchmarks.first,
            benchmarks.count > 0
        else {
            XCTFail("benchmarks not set")
            return
        }
        XCTAssertEqual(benchmarks[0].conceptID, 1)
        XCTAssertEqual(benchmarks[0].correctAnswersRequired, 4)
        XCTAssertEqual(benchmarks[0].correctAnswersOutOf, 6)
    }
    
    func test_beginPracticeOneConceptLearningStep_shouldRefreshExercises() {
        let mockExerciseStore = FakeFeedExercisesStore()
        let coordinator = composeSUT(fakeExerciseStore: mockExerciseStore,
                                     stubLearningStep: practiceLS1)
        
        coordinator.start()
        
        XCTAssertEqual(mockExerciseStore.refresh_callCount, 1)
        XCTAssertEqual(mockExerciseStore.refresh_conceptIDs, [[1]])
    }
    
    func test_practiceOneConceptComplete_shouldShowLevelUpScene() {
        let mockContainer = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainer, stubLearningStep: practiceLS1, stubProgressState: ProgressState(required: 1, correct: 1))
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        guard let _ = mockContainer.show_viewController.last as? LevelUpViewController else {
            XCTFail("Level up vc not displayed")
            return
        }
    }
    
    func test_practiceOneConceptLevelUp_shouldUpdateUserConceptStrength() {
        let mockUserConceptEDS = FakeUserConceptExternalDataService()
        let coordinator = composeSUT(stubLearningStep: practiceLS1, stubProgressState: ProgressState(required: 5, correct: 5), fakeUserConceptEDS: mockUserConceptEDS)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        XCTAssertEqual(mockUserConceptEDS.update_callCount, 1)
        XCTAssertEqual(mockUserConceptEDS.update_id.first, 1)
        XCTAssertEqual(mockUserConceptEDS.update_fields.first?["strength"], "2")
    }
    
    func test_practiceOneConceptLevelUp_shouldRefreshLearningStep() {
        let mockLearningStepStore = FakeLearningStepStore()
        let coordinator = composeSUT(fakeLearningStepStore: mockLearningStepStore, stubLearningStep: practiceLS1, stubProgressState: ProgressState(required: 5, correct: 5))
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        XCTAssertEqual(mockLearningStepStore.next_callCount, 1)
    }
    
    //MARK: - Practice Two Concepts Learning Step
    
    func test_levelUpRequestsNext_practiceTwoLearningStep_shouldShowPracticeIntro() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: practiceLS12)
        
        coordinator.start()
        coordinator.next(TestLevelUpViewModel())
        
        XCTAssertEqual(mockContainerVC.show_callCount, 2)
        mockContainerVC.verifyDidShow(viewControllerType: PracticeIntroViewController.self)
    }
    
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
    
    func test_showDoubleLevelUp_shouldIncrementLevelsOnRemote() {
        let stubProgressState = ProgressState(required: 5, correct: 5)
        let mockUserConceptEDS = FakeUserConceptExternalDataService()
        let coordinator = composeSUT(stubLearningStep: practiceLS12, stubProgressState: stubProgressState, fakeUserConceptEDS: mockUserConceptEDS)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        XCTAssertEqual(mockUserConceptEDS.update_callCount, 2)
        XCTAssertEqual(mockUserConceptEDS.update_id, [1, 2])
    }
    
    func test_doubleLevelUp_next_shouldShowNextLearningStepIntro() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: practiceLS12)

        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        coordinator.next(TestDoubleLevelUpViewModel())

        mockContainerVC.verifyDidShow(viewControllerType: PracticeIntroViewController.self)
    }
    
    func test_doubleLevelUp_next_shouldShowNextLearningStepIntro2() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: conceptIntroLS2)

        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        coordinator.next(TestDoubleLevelUpViewModel())

        mockContainerVC.verifyDidShow(viewControllerType: ConceptIntroViewController.self)
    }
    
    func test_doubleLevelUp_shouldRefreshLearningStep() {
        let stubProgressState = ProgressState(required: 5, correct: 5)
        let mockLearningStepStore = FakeLearningStepStore()
        let coordinator = composeSUT(fakeLearningStepStore: mockLearningStepStore, stubLearningStep: practiceLS12, stubProgressState: stubProgressState)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        XCTAssertEqual(mockLearningStepStore.next_callCount, 1)
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
    
    //MARK: - Practice Family Learning Step
    
    func test_nextLearningStep_practiceFamily_shouldShowPracticeIntro() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: practiceFamilyLS)
        
        coordinator.start()
        
        XCTAssertEqual(mockContainerVC.show_callCount, 1)
        mockContainerVC.verifyDidShow(viewControllerType: PracticeIntroViewController.self)
    }
    
    func test_practiceFamilyLearningStep_shouldSetResultBenchmarks() {
        let mockResultsStore = FakeResultsStore()
        let coordinator = composeSUT(fakeResultsStore: mockResultsStore, stubLearningStep: practiceFamilyLS)
        
        coordinator.start()
        
        XCTAssertEqual(mockResultsStore.setBenchmarks_callCount, 1)
        let benchmarks = mockResultsStore.setBenchmarks_benchmarks.first ?? []
        XCTAssertEqual(benchmarks.map { $0.conceptID }, [1,2,3,4,5])
        XCTAssertEqual(benchmarks.map { $0.correctAnswersOutOf }, [3,3,3,3,3])
        XCTAssertEqual(benchmarks.map { $0.correctAnswersRequired }, [2,2,2,2,2])
    }
    
    func test_practiceFamilyLearningStep_shouldRefreshExercises() {
        let mockExerciseStore = FakeFeedExercisesStore()
        let coordinator = composeSUT(fakeExerciseStore: mockExerciseStore,
                                     stubLearningStep: practiceFamilyLS)
        
        coordinator.start()
        
        XCTAssertEqual(mockExerciseStore.refresh_callCount, 1)
        XCTAssertEqual(mockExerciseStore.refresh_conceptIDs, [[1,2,3,4,5]])
    }
    
    func test_practiceFamilyLearningStepComplete_shouldShowPracticeFamilyCompleteScene() {
        let mockContainer = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainer, stubLearningStep: practiceFamilyLS, stubProgressState: ProgressState(required: 1, correct: 1))
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        guard let _ = mockContainer.show_viewController.last as? PracticeFamilyCompleteViewController else {
            XCTFail("Practice Family Complete vc not displayed")
            return
        }
    }
    
    //MARK: - Concept Group Complete Step
    
    func test_nextLearningStep_transitionGroup1To2_shouldShowTransitionConceptGroupScene() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: transitionGroup1To2LS)
        
        coordinator.start()
        
        mockContainerVC.verifyDidShow(viewControllerType: GroupCompleteViewController.self)
    }
    
    func test_transitionGroup1To2_shouldRefreshQueuedLearningStep() {
        let mockLearningStepStore = FakeLearningStepStore()
        let coordinator = composeSUT(fakeLearningStepStore: mockLearningStepStore, stubLearningStep: transitionGroup1To2LS)
        
        coordinator.start()
        
        XCTAssertEqual(mockLearningStepStore.next_callCount, 1)
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
        XCTAssertEqual(levelUpVC.conceptLabel.text, "Stub rule")
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
    
    func test_diagramExercise_shouldShowDiagramExerciseScene() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubExercises: [Exercise.createStub(diagram: "TestDiagram")])
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        mockContainerVC.verifyDidShow(viewControllerType: DiagramExerciseViewController.self)
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
    
    func test_levelUpRequestsNext_conceptIntroLearningStep_shouldShowConceptIntro() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: conceptIntroLS1)
        
        coordinator.start()
        coordinator.next(TestLevelUpViewModel())
        
        XCTAssertEqual(mockContainerVC.show_callCount, 2)
        mockContainerVC.verifyDidShow(viewControllerType: ConceptIntroViewController.self)
    }
    
    func test_levelUpRequestsNext_practiceTwoLearningStep_shouldRefreshExercises() {
        let mockExerciseStore = FakeFeedExercisesStore()
        let coordinator = composeSUT(fakeExerciseStore: mockExerciseStore,
                                     stubLearningStep: practiceLS12,
                                     stubExercises: [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3])
        
        coordinator.start()
        
        XCTAssertEqual(mockExerciseStore.refresh_callCount, 1)
    }
    
    //MARK: - Show Exercise
    
    func test_showExerciseByID_shouldFetchExercise() {
        let mockExerciseEDS = FakeExerciseExternalDataService()
        mockExerciseEDS.stubExercise = Exercise.exercise2
        let coordinator = composeSUT(stubLearningStep: conceptIntroLS1, fakeExerciseEDS: mockExerciseEDS)
        
        coordinator.start()
        coordinator.loadExercise(TestMenuCoordinator(), withID: 2)
        
        XCTAssertEqual(mockExerciseEDS.get_callCount, 1)
    }
    
    func test_showExerciseByID_shouldShowExerciseScene() {
        let mockContainerVC = FakeContainerViewController()
        let stubExerciseEDS = FakeExerciseExternalDataService()
        stubExerciseEDS.stubExercise = Exercise.exercise2
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC,
                                     stubLearningStep: conceptIntroLS1,
                                     fakeExerciseEDS: stubExerciseEDS)
        
        coordinator.start()
        coordinator.loadExercise(TestMenuCoordinator(), withID: 2)
        
        XCTAssertEqual(mockContainerVC.show_callCount, 2)
        mockContainerVC.verifyDidShow(viewControllerType: ExerciseViewController.self)
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
                    fakeUserConceptEDS: FakeUserConceptExternalDataService? = nil,
                    fakeExerciseEDS: FakeExerciseExternalDataService? = nil) -> FeedCoordinator {
        
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
        let exerciseEDS = fakeExerciseEDS ?? FakeExerciseExternalDataService()
        
        return FeedCoordinator(composer: FeedComposer_DeadLoadScene(resultsStore: resultsStore),
                               globalComposer: GlobalComposer(),
                               containerVC: containerVC,
                               randomizationService: RandomizationServiceImpl(),
                                   resultsStore: resultsStore,
                                   learningStepStore: learningStepStore,
                                   exercisesStore: exercisesStore,
                                   userConceptEDS: userConceptEDS,
                                   exerciseEDS: exerciseEDS)
    }
    
    //MARK: - Stubs
    
    var conceptIntroLS1: ConceptIntroLearningStep = ConceptIntroLearningStep.createWithConceptID(conceptID: 1)
    var conceptIntroLS2: ConceptIntroLearningStep = ConceptIntroLearningStep.createWithConceptID(conceptID: 2)
    
    var practiceLS1: PracticeOneConceptLearningStep = PracticeOneConceptLearningStep.createStub(concept: Concept.constantRule)
    
    var practiceLS12: PracticeTwoConceptsLearningStep = PracticeTwoConceptsLearningStep.createStub(concept1: Concept.constantRule, concept2: Concept.linearRule)
    
    var practiceFamilyLS = PracticeFamilyLearningStep.createStub()
    
    var transitionGroup1To2LS = TransitionLearningStep.transitionGroup1To2
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

class TestConceptIntroViewModel: ConceptIntroViewModelImpl {
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

class FeedComposer_DeadLoadScene: FeedComposer {
    override func composeLoadExercisesScene(delegate: LoadExercisesViewModelDelegate) -> UIViewController {
        let vm = LoadExercisesViewModel(delegate: FakeLoadExercisesViewModelDelegate())
        return LoadExercisesViewController(viewModel: vm)
    }
}

class TestDoubleLevelUpViewModel: DoubleLevelUpViewModel {
    init() {
        super.init(delegate: FakeDoubleLevelUpViewModelDelegate(), levelUpItem1: LevelUpItem.constantRuleItem, levelUpItem2: LevelUpItem.constantRuleItem)
    }
}
