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
        let stubLearningStep = ConceptIntroLearningStep.createWithConceptID(conceptID: 1)
        let stubExercises = [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubLearningStep: stubLearningStep, stubExercises: stubExercises)
        
        coordinator.start()
        coordinator.next(TestConceptIntroViewModel())
        
        mockContainerVC.verifyDidShow(viewControllerType: ExerciseViewController.self)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeContainerViewController: ContainerViewController? = nil,
                    fakeLearningStepStore: FakeLearningStepStore? = nil,
                    fakeExerciseStore: FakeFeedExercisesStore? = nil,
                    stubLearningStep: LearningStep? = nil,
                    stubExercises: [Exercise]? = nil) -> FeedCoordinator {
        
        let containerVC = fakeContainerViewController ?? FakeContainerViewController()
        let learningStepStore = fakeLearningStepStore ?? FakeLearningStepStore()
        if let stubLearningStep = stubLearningStep {
            learningStepStore.learningStep = Observable.just(.loaded(stubLearningStep))
        }
        let exercisesStore = fakeExerciseStore ?? FakeFeedExercisesStore()
        if let stubExercises = stubExercises {
            exercisesStore.exercises = Observable.just(.loaded(stubExercises))
        }
        
        return FeedCoordinator(compositionRoot: CompositionRoot(),
                                   containerVC: containerVC,
                                   randomizationService: RandomizationServiceImpl(),
                                   resultsStore: FakeResultsStore(),
                                   learningStepStore: learningStepStore,
                                   exercisesStore: exercisesStore)
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
        super.init(delegate: FakeConceptIntroViewModelDelegate(), conceptIntro: ConceptIntro(concept: Concept.constantRule))
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
