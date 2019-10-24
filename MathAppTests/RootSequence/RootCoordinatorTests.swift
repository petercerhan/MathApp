//
//  RootCoordinatorTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 8/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class RootCoordinatorTests: XCTestCase {
    
    func test_start_shouldShowPrepareFeedScene() {
        let mockContainer = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainer: mockContainer)
        
        coordinator.start()
        
        mockContainer.verifyDidShow(viewControllerType: PrepareFeedViewController.self)
    }
    
    func test_start_shouldSetupDatabaseService() {
        let mockDatabaseService = FakeDatabaseService()
        let coordinator = composeSUT(fakeDatabaseService: mockDatabaseService)
        
        coordinator.start()
        
        XCTAssertEqual(mockDatabaseService.setup_callCount, 1)
    }
    
    func test_prepareFeedRequestsNext_shouldShowFeedSequence() {
        let mockContainer = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainer: mockContainer)
        
        coordinator.start()
        coordinator.next(TestPrepareFeedViewModel())
        
        let assertion = {
            mockContainer.verifyDidShow(viewControllerType: ContainerViewController.self)
            XCTAssert(coordinator.childCoordinator is FeedCoordinator)
        }
        delayedAssertion(delay: 0.2, assertion)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeContainer: FakeContainerViewController? = nil, fakeDatabaseService: FakeDatabaseService? = nil) -> RootCoordinator {
        let container = fakeContainer ?? FakeContainerViewController()
        let databaseService = fakeDatabaseService ?? FakeDatabaseService()
        
        return RootCoordinator(compositionRoot: RootCoordinatorFakeCompositionRoot(), containerVC: container, databaseService: databaseService, feedPackageStore: FakeFeedPackageStore())
    }
    
}

class RootCoordinatorFakeCompositionRoot: CompositionRoot {
    override func composeExerciseCoordinator(feedPackageStore: FeedPackageStore) -> FeedCoordinator {
        return FeedCoordinator(compositionRoot: CompositionRoot(),
                                   containerVC: ContainerViewController(),
                                   randomizationService: RandomizationServiceImpl(),
                                   feedPackageExternalDataService: FakeFeedPackageExternalDataService(),
                                   resultsStore: FakeResultsStore(),
                                   learningStepStore: FakeLearningStepStore(),
                                   exercisesStore: FakeFeedExercisesStore())
    }
    
    override func composePrepareFeedScene(delegate: PrepareFeedViewModelDelegate, feedPackageStore: FeedPackageStore) -> UIViewController {
        let vm = PrepareFeedViewModel(delegate: delegate, learningStepStore: FakeLearningStepStore())
        return PrepareFeedViewController(viewModel: vm)
    }
}

class TestPrepareFeedViewModel: PrepareFeedViewModel {
    init() {
        super.init(delegate: FakePrepareFeedViewModelDelegate(), learningStepStore: FakeLearningStepStore())
    }
}
