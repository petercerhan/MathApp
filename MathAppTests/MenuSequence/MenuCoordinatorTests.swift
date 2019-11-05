//
//  MenuCoordinatorTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

class MenuCoordinatorTests: XCTestCase {
    
    func test_start_shouldShowMenuScene() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainer: mockContainerVC)
        
        coordinator.start()
        
        mockContainerVC.verifyDidShow(viewControllerType: MenuViewController.self)
    }
    
    func test_containerRequestsQuit_shouldRequestToQuit() {
        let mockDelegate = FakeMenuCoordinatorDelegate()
        let coordinator = composeSUT(fakeDelegate: mockDelegate)
        
        coordinator.start()
        coordinator.quit(TestQuitableContainerViewModel())
        
        XCTAssertEqual(mockDelegate.quit_callCount, 1)
    }
    
    func test_menuRequestsConceptMap_shouldShowConceptMap() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainer: mockContainerVC)
        
        coordinator.start()
        coordinator.conceptMap(TestMenuViewModel())
        
        mockContainerVC.verifyDidShow(viewControllerType: ConceptMapViewController.self)
    }
    
    func test_conceptMapRequestsBack_shouldShowMenuScene() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainer: mockContainerVC)
        
        coordinator.start()
        coordinator.conceptMap(TestMenuViewModel())
        coordinator.back(TestConceptMapViewModel())
        
        mockContainerVC.verifyDidShow(viewControllerType: MenuViewController.self)
    }
    
    func test_menuRequestsChooseExercise_shouldShowChooseExercise() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainer: mockContainerVC)
        
        coordinator.start()
        coordinator.chooseExercise(TestMenuViewModel())
        
        mockContainerVC.verifyDidShow(viewControllerType: ChooseExerciseViewController.self)
    }
    
    func test_chooseExerciseRequestsBack_shouldShowMenuScene() {
        let mockContainerVC = FakeContainerViewController()
        let coordinator = composeSUT(fakeContainer: mockContainerVC)
        
        coordinator.start()
        coordinator.chooseExercise(TestMenuViewModel())
        coordinator.back(TestChooseExerciseViewModel())
        
        mockContainerVC.verifyDidShow(viewControllerType: MenuViewController.self)
    }
    
    func test_loadExerciseRequest_id9_shouldForwardRequestToDelegate() {
        let mockDelegate = FakeMenuCoordinatorDelegate()
        let coordinator = composeSUT(fakeDelegate: mockDelegate)
        
        coordinator.start()
        coordinator.loadExercise(TestChooseExerciseViewModel(), withID: 9)
        
        XCTAssertEqual(mockDelegate.loadExercise_count, 1)
        XCTAssertEqual(mockDelegate.loadExercise_id.last, 9)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeDelegate: MenuCoordinatorDelegate? = nil, fakeContainer: FakeContainerViewController? = nil) -> MenuCoordinator {
        let delegate = fakeDelegate ?? FakeMenuCoordinatorDelegate()
        let container = fakeContainer ?? FakeContainerViewController()
        return MenuCoordinator(delegate: delegate, containerVC: container, compositionRoot: GlobalComposer())
    }
    
    
}

class TestQuitableContainerViewModel: QuitableContainerViewModelImpl {
    init() {
        super.init(delegate: FakeQuitableWorldViewModelDelegate())
    }
}

class TestMenuViewModel: MenuViewModel {
    init() {
        super.init(delegate: FakeMenuViewModelDelegate(), databaseService: FakeDatabaseService())
    }
}

class TestConceptMapViewModel: ConceptMapViewModel {
    init() {
        super.init(delegate: FakeConceptMapViewModelDelegate(), databaseService: FakeDatabaseService())
    }
}

class TestChooseExerciseViewModel: ChooseExerciseViewModel {
    init() {
        super.init(delegate: FakeChooseExerciseViewModelDelegate())
    }
}
