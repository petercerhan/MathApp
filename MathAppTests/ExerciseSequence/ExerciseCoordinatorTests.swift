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
        let feedPackage = FeedPackage.createExercisesStub(exercises: [Exercise.exercise1, Exercise.exercise4, Exercise.exercise7])
        let coordinator = composeSUT(fakeContainerViewController: mockContainerVC, stubFeedPackage: feedPackage)
        
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
        let feedPackage = FeedPackage.createExercisesStub(exercises: [Exercise.exercise1, Exercise.exercise4, Exercise.exercise7])
        let coordinator = composeSUT(fakeExercisesStore: mockExercisesStore, stubFeedPackage: feedPackage)
        
        coordinator.start()
        coordinator.next(TestExerciseViewModel())
        coordinator.next(TestExerciseViewModel())
        
        XCTAssertEqual(mockExercisesStore.updateExercises_callCount, 1)
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
    
    
    
    
    func test_start_conceptIntroFeedPackage_shouldShowConceptIntro() {
        let mockContainer = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainer, stubFeedPackage: FeedPackage.constantRuleIntro)
        
        coordinator.start()
        
        mockContainer.verifyDidShow(viewControllerType: ConceptIntroViewController.self)
    }
    
    func test_start_conceptIntroDisplayed_shouldSetTransitionItemSeen() {
        let mockExercisesStore = FakeExercisesStore()
        let coordinator = composeSUT(fakeExercisesStore: mockExercisesStore, stubFeedPackage: FeedPackage.constantRuleIntro)
        
        coordinator.start()
        
        XCTAssertEqual(mockExercisesStore.setTransitionItemSeen_callCount, 1)
    }
    
    func test_conceptIntroRequestsNext_exercisesLoaded_shouldShowExercise() {
        let mockContainer = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainerViewController: mockContainer, stubFeedPackages: [FeedPackage.constantRuleIntro, FeedPackage.exercisesPackage])

        coordinator.start()
        coordinator.next(TestConceptIntroViewModel())

        mockContainer.verifyDidShow(viewControllerType: ExerciseViewController.self)
    }
    
    //test that concept intro seen updates user-concept to introduced & in progress
    
    //test that if exercise has been shown and then we refresh and get concept intro, shows exercise first, then if correct shows concept intro
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeContainerViewController: ContainerViewController? = nil,
                    fakeExerciseExternalDataService: FakeExerciseExternalDataService? = nil,
                    fakeExercisesStore: FakeExercisesStore? = nil,
                    stubFeedPackage: FeedPackage? = nil,
                    stubFeedPackages: [FeedPackage]? = nil,
                    feedPackageLoadState: LoadState<FeedPackage>? = nil,
                    compositionRoot: CompositionRoot? = nil) -> ExerciseCoordinator {
        
        let containerVC = fakeContainerViewController ?? FakeContainerViewController()
        let exerciseExternalDataService = fakeExerciseExternalDataService ?? FakeExerciseExternalDataService()
        let exercisesStore = fakeExercisesStore ?? FakeExercisesStore()
        
        let feedPackage = stubFeedPackage ?? FeedPackage.exercisesPackage
        exercisesStore.setStubFeedPackage(feedPackage)
        
        if let feedPackages = stubFeedPackages {
            exercisesStore.setStubFeedPackages(feedPackages)
        }
        
        if let feedPackageLoadState = feedPackageLoadState {
            exercisesStore.setStubFeedPackageLoadState(feedPackageLoadState)
        }
        
        let inputCompositionRoot = compositionRoot ?? CompositionRoot()
        
        return ExerciseCoordinator(compositionRoot: inputCompositionRoot,
                                   containerVC: containerVC,
                                   randomizationService: RandomizationServiceImpl(),
                                   exerciseExternalDataService: exerciseExternalDataService,
                                   resultsStore: FakeResultsStore(),
                                   feedPackageStore: exercisesStore)
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
        super.init(delegate: FakeLoadExercisesViewModelDelegate(), feedPackageStore: FakeExercisesStore())
    }
}

class TestConceptIntroViewModel: ConceptIntroViewModel {
    init() {
        super.init(delegate: FakeConceptIntroViewModelDelegate(), conceptIntro: ConceptIntro(concept: Concept.constantRule))
    }
}

class CompositionRoot_deadLoadScene: CompositionRoot {
    override func composeLoadExercisesScene(delegate: LoadExercisesViewModelDelegate, feedPackageStore: FeedPackageStore) -> UIViewController {
        let vm = LoadExercisesViewModel(delegate: FakeLoadExercisesViewModelDelegate(), feedPackageStore: feedPackageStore)
        return LoadExercisesViewController(viewModel: vm)
    }
}
