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
    
//    func test_start_shouldShowFeedSequence() {
//        let mockContainer = FakeContainerViewController()
//        let coordinator = composeSUT(fakeContainer: mockContainer)
//
//        coordinator.start()
//
//        mockContainer.verifyDidShow(viewControllerType: ContainerViewController.self)
//        XCTAssert(coordinator.childCoordinator is ExerciseCoordinator)
//    }
    
    func test_start_shouldSetupDatabaseService() {
        let mockDatabaseService = FakeDatabaseService()
        let coordinator = composeSUT(fakeDatabaseService: mockDatabaseService)
        
        coordinator.start()
        
        XCTAssertEqual(mockDatabaseService.setup_callCount, 1)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeContainer: FakeContainerViewController? = nil, fakeDatabaseService: FakeDatabaseService? = nil) -> RootCoordinator {
        let container = fakeContainer ?? FakeContainerViewController()
        let databaseService = fakeDatabaseService ?? FakeDatabaseService()
        
        return RootCoordinator(compositionRoot: RootCoordinatorFakeCompositionRoot(), containerVC: container, databaseService: databaseService)
    }
    
}

class RootCoordinatorFakeCompositionRoot: CompositionRoot {
    override func composeExerciseCoordinator() -> ExerciseCoordinator {
        return ExerciseCoordinator(compositionRoot: CompositionRoot(),
                                   containerVC: ContainerViewController(),
                                   randomizationService: RandomizationServiceImpl(),
                                   exerciseExternalDataService: FakeExerciseExternalDataService(),
                                   resultsStore: FakeResultsStore(),
                                   feedPackageStore: FakeFeedPackageStore())
    }
    
    override func composePrepareFeedScene() -> UIViewController {
        let vm = PrepareFeedViewModel(feedPackageStore: FakeFeedPackageStore())
        return PrepareFeedViewController(viewModel: vm)
    }
}
