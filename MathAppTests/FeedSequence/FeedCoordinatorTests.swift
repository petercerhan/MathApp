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
        let stubLearningStepStore = FakeLearningStepStore()
        stubLearningStepStore.learningStep = Observable.just(.loaded(ConceptIntroLearningStep.createWithConceptID(conceptID: 1)))
        
        
        
    }
    
    //MARK: - Exercise Packages
    
    func test_start_exercisesFeedPackage_shouldShowExerciseScene() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC)
        
        coordinator.start()
        
        mockContainerVC.verifyDidShow(viewControllerType: ExerciseViewController.self)
    }
    
    func test_start_noExercisesLoaded_shouldShowLoadExercisesScene() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, feedPackageLoadState: .loading)
        
        coordinator.start()
        
        mockContainerVC.verifyDidShow(viewControllerType: LoadExercisesViewController.self)
    }
    
    func test_exerciseSceneRequestsNext_shouldShowNextExercise() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC)

        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
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
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, feedPackageLoadState: .loading, compositionRoot: CompositionRoot_deadLoadScene())
        
        coordinator.start()
        coordinator.next(TestLoadExercisesViewModel())
        
        let assertion = {
            mockContainerVC.verifyDidShow(viewControllerType: ExerciseViewController.self)
        }
        delayedAssertion(assertion)
    }
    
    func test_threeExercises_showInOrderAndRequestRefreshAfterThirdLoaded() {
        let mockContainerVC = FakeContainerViewController()
        let feedPackage = FeedPackage.createExercisesStub(exercises: [Exercise.exercise1, Exercise.exercise4, Exercise.exercise7])
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubFeedPackage: feedPackage)
        
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
        let feedPackage = FeedPackage.createExercisesStub(exercises: [Exercise.exercise1, Exercise.exercise4, Exercise.exercise7])
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubFeedPackage: feedPackage)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
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
        let feedPackage = FeedPackage.createExercisesStub(exercises: [Exercise.exercise1, Exercise.exercise4, Exercise.exercise7])
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubFeedPackage: feedPackage)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
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
        let mockfeedPackageStore = FakeFeedPackageStore()
        let feedPackage = FeedPackage.createExercisesStub(exercises: [Exercise.exercise1, Exercise.exercise4, Exercise.exercise7])
        let coordinator = composeSUT(fakeFeedPackageStore: mockfeedPackageStore, stubFeedPackage: feedPackage)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        XCTAssertEqual(mockfeedPackageStore.updateFeedPackage_callCount, 1)
    }
    
    func test_loadExercise_id1_shouldLoadExerciseID1FromDatabaseService() {
        let mockExerciseExternalDataService = FakeExerciseExternalDataService()
        let coordinator = composeSUT(fakeExerciseExternalDataService: mockExerciseExternalDataService)
        
        coordinator.start()
        coordinator.loadExercise(TestMenuCoordinator(), withID: 1)
        
        XCTAssertEqual(mockExerciseExternalDataService.getExercise_callCount, 1)
        XCTAssertEqual(mockExerciseExternalDataService.getExercise_id.first, 1)
    }
    
    func test_loadExercise_exercise8_shouldShowExercise8() {
        let mockContainerVC = FakeContainerViewController()
        let stubExerciseExternalDataService = FakeExerciseExternalDataService()
        stubExerciseExternalDataService.getExercise_stubData = Exercise.exercise8
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, fakeExerciseExternalDataService: stubExerciseExternalDataService)
        
        coordinator.start()
        coordinator.loadExercise(TestMenuCoordinator(), withID: 8)
        
        if mockContainerVC.show_viewController.count > 1,
            let vc = mockContainerVC.show_viewController[1] as? ExerciseViewController
        {
            vc.loadViewIfNeeded()
            XCTAssertEqual(vc.questionLatexLabel.latex, Exercise.exercise8.questionLatex)
        } else {
            XCTFail("ExerciseViewController not presented")
        }
    }
    
    func test_loadExercise_shouldDismissMenu() {
        let mockContainer = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainer)
        
        coordinator.start()
        coordinator.loadExercise(TestMenuCoordinator(), withID: 1)
        
        XCTAssertEqual(mockContainer.dismissModal_callCount, 1)
    }
    
    
    //MARK: - Concept Intro Packages
    
    func test_start_conceptIntroFeedPackage_shouldShowConceptIntro() {
        let mockContainer = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainer, stubFeedPackage: FeedPackage.constantRuleIntro)
        
        coordinator.start()
        
        mockContainer.verifyDidShow(viewControllerType: ConceptIntroViewController.self)
    }
    
    func test_start_conceptIntroDisplayed_shouldSetConceptIntroSeen() {
        let mockfeedPackageStore = FakeFeedPackageStore()
        let coordinator = composeSUT(fakeFeedPackageStore: mockfeedPackageStore, stubFeedPackage: FeedPackage.constantRuleIntro)
        
        coordinator.start()
        
        XCTAssertEqual(mockfeedPackageStore.setConceptIntroSeen_callCount, 1)
    }
    
    func test_conceptIntroRequestsNext_exercisesLoaded_shouldShowExercise() {
        let mockContainer = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainer, stubFeedPackages: [FeedPackage.constantRuleIntro, FeedPackage.exercisesPackage])

        coordinator.start()
        coordinator.next(TestConceptIntroViewModel())

        mockContainer.verifyDidShow(viewControllerType: ExerciseViewController.self)
    }
    
    func test_exerciseAnsweredCorrectly_conceptIntroQueued_shouldPresentConceptIntro() {
        let mockContainer = FakeContainerViewController()
        let singleExercisePackage = FeedPackage(feedPackageType: .exercises, exercises: [Exercise.exercise1], transitionItem: nil)
        let feedPackages = [singleExercisePackage, FeedPackage.constantRuleIntro, FeedPackage.exercisePackage2]
        let coordinator = composeSUT(fakeContainerViewController: mockContainer, stubFeedPackages: feedPackages)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        mockContainer.verifyDidShow(viewControllerType: ConceptIntroViewController.self)
    }
    
    func test_exerciseAnsweredIncorrectly_conceptIntroQueued_shouldShowExercise() {
        let mockContainer = FakeContainerViewController()
        let singleExercisePackage = FeedPackage(feedPackageType: .exercises, exercises: [Exercise.exercise1], transitionItem: nil)
        let feedPackages = [singleExercisePackage, FeedPackage.constantRuleIntro, FeedPackage.exercisePackage2]
        let coordinator = composeSUT(fakeContainerViewController: mockContainer, stubFeedPackages: feedPackages)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: false)
        
        mockContainer.verifyDidShow(viewControllerType: ExerciseViewController.self)
    }
    
    func test_exerciseIncorrectThenCorrect_conceptIntroQueued_shouldPresentConceptIntro() {
        let mockContainer = FakeContainerViewController()
        let singleExercisePackage = FeedPackage(feedPackageType: .exercises, exercises: [Exercise.exercise1], transitionItem: nil)
        let feedPackages = [singleExercisePackage, FeedPackage.constantRuleIntro, FeedPackage.exercisePackage2]
        let coordinator = composeSUT(fakeContainerViewController: mockContainer, stubFeedPackages: feedPackages)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: false)
        coordinator.next(TestExerciseViewModel(), correctAnswer: true)
        
        mockContainer.verifyDidShow(viewControllerType: ConceptIntroViewController.self)
    }
    
    func test_conceptIntroQueued_seriesOfIncorrectAnswers_shouldNotRefreshFeedPackage() {
        let mockFeedPackageStore = FakeFeedPackageStore()
        let singleExercisePackage = FeedPackage(feedPackageType: .exercises, exercises: [Exercise.exercise1], transitionItem: nil)
        let feedPackages = [singleExercisePackage, FeedPackage.constantRuleIntro, FeedPackage.exercisePackage2]
        let coordinator = composeSUT(fakeFeedPackageStore: mockFeedPackageStore, stubFeedPackages: feedPackages)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: false)
        coordinator.next(TestExerciseViewModel(), correctAnswer: false)
        coordinator.next(TestExerciseViewModel(), correctAnswer: false)
        coordinator.next(TestExerciseViewModel(), correctAnswer: false)
        coordinator.next(TestExerciseViewModel(), correctAnswer: false)
        
        XCTAssertEqual(mockFeedPackageStore.updateFeedPackage_callCount, 1)
    }
    
    //MARK: - Level Up Packages
    
    func test_start_levelUpFeedPackage_shouldShowLevelUp() {
        let mockContainer = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainer, stubFeedPackage: FeedPackage.constantRuleLevelUp)
        
        coordinator.start()
        
        mockContainer.verifyDidShow(viewControllerType: LevelUpViewController.self)
    }
    
    func test_start_levelUpDisplayed_shouldSetLevelUpSeen() {
        let mockFeedPackageStore = FakeFeedPackageStore()
        let coordinator = composeSUT(fakeFeedPackageStore: mockFeedPackageStore, stubFeedPackage: FeedPackage.constantRuleLevelUp)
        
        coordinator.start()
        
        XCTAssertEqual(mockFeedPackageStore.setLevelUpSeen_callCount, 1)
    }
    
    func test_levelUpQueued_seriesOfIncorrectAnswers_shouldNotRefreshFeedPackage() {
        let mockFeedPackageStore = FakeFeedPackageStore()
        let singleExercisePackage = FeedPackage(feedPackageType: .exercises, exercises: [Exercise.exercise1], transitionItem: nil)
        let feedPackages = [singleExercisePackage, FeedPackage.constantRuleLevelUp, FeedPackage.exercisePackage2]
        let coordinator = composeSUT(fakeFeedPackageStore: mockFeedPackageStore, stubFeedPackages: feedPackages)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel(), correctAnswer: false)
        coordinator.next(TestExerciseViewModel(), correctAnswer: false)
        coordinator.next(TestExerciseViewModel(), correctAnswer: false)
        coordinator.next(TestExerciseViewModel(), correctAnswer: false)
        coordinator.next(TestExerciseViewModel(), correctAnswer: false)
        
        XCTAssertEqual(mockFeedPackageStore.updateFeedPackage_callCount, 1)
    }
    
    func test_levelUpRequestsNext_conceptIntroQueued_shouldShowConceptIntro() {
        let mockContainer = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainer, stubFeedPackages: [FeedPackage.constantRuleLevelUp, FeedPackage.constantRuleIntro])
        
        coordinator.start()
        coordinator.next(TestLevelUpViewModel())
        
        mockContainer.verifyDidShow(viewControllerType: ConceptIntroViewController.self)
    }
    
    func test_levelUpRequestsNext_exercisesLoaded_shouldShowExerciseScene() {
        let mockContainer = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainer, stubFeedPackages: [FeedPackage.constantRuleLevelUp, FeedPackage.exercisesPackage])
        
        coordinator.start()
        coordinator.next(TestLevelUpViewModel())
        
        mockContainer.verifyDidShow(viewControllerType: ExerciseViewController.self)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeContainerViewController: ContainerViewController? = nil,
                    fakeExerciseExternalDataService: FakeExerciseExternalDataService? = nil,
                    fakeFeedPackageStore: FakeFeedPackageStore? = nil,
                    stubFeedPackage: FeedPackage? = nil,
                    stubFeedPackages: [FeedPackage]? = nil,
                    feedPackageLoadState: LoadState<FeedPackage>? = nil,
                    compositionRoot: CompositionRoot? = nil) -> FeedCoordinator {
        
        let containerVC = fakeContainerViewController ?? FakeContainerViewController()
        let exerciseExternalDataService = fakeExerciseExternalDataService ?? FakeExerciseExternalDataService()
        let feedPackageStore = fakeFeedPackageStore ?? FakeFeedPackageStore()
        
        let feedPackage = stubFeedPackage ?? FeedPackage.exercisesPackage
        feedPackageStore.setStubFeedPackage(feedPackage)
        
        if let feedPackages = stubFeedPackages {
            feedPackageStore.setStubFeedPackages(feedPackages)
        }
        
        if let feedPackageLoadState = feedPackageLoadState {
            feedPackageStore.setStubFeedPackageLoadState(feedPackageLoadState)
        }
        
        let inputCompositionRoot = compositionRoot ?? CompositionRoot()
        
        return FeedCoordinator(compositionRoot: inputCompositionRoot,
                                   containerVC: containerVC,
                                   randomizationService: RandomizationServiceImpl(),
                                   feedPackageExternalDataService: exerciseExternalDataService,
                                   resultsStore: FakeResultsStore(),
                                   feedPackageStore: feedPackageStore,
                                   learningStepStore: FakeLearningStepStore())
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
        super.init(delegate: FakeLoadExercisesViewModelDelegate(), feedPackageStore: FakeFeedPackageStore())
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
    override func composeLoadExercisesScene(delegate: LoadExercisesViewModelDelegate, feedPackageStore: FeedPackageStore) -> UIViewController {
        let vm = LoadExercisesViewModel(delegate: FakeLoadExercisesViewModelDelegate(), feedPackageStore: feedPackageStore)
        return LoadExercisesViewController(viewModel: vm)
    }
}