//
//  MenuSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

class MenuSceneTests: XCTestCase {
    
    func test_conceptMapPressed_shouldRequestConceptMap() {
        let mockDelegate = FakeMenuViewModelDelegate()
        let vc = composeSUT(fakeDelegate: mockDelegate)
        
        vc.loadViewIfNeeded()
        vc.conceptMapButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.conceptMap_callCount, 1)
    }
    
    func test_resetDB_shouldRequestDBReset() {
        let mockDatabaseService = FakeDatabaseService()
        let vc = composeSUT(fakeDatabaseService: mockDatabaseService)
        
        vc.loadViewIfNeeded()
        vc.resetDBButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDatabaseService.reset_callCount, 1)
    }
    
    func test_chooseExercise_shouldRequestChooseExercise() {
        let mockDelegate = FakeMenuViewModelDelegate()
        let vc = composeSUT(fakeDelegate: mockDelegate)
        
        vc.loadViewIfNeeded()
        vc.chooseExerciseButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.chooseExercise_callCount, 1)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeDelegate: FakeMenuViewModelDelegate? = nil, fakeDatabaseService: FakeDatabaseService? = nil) -> MenuViewController {
        let delegate = fakeDelegate ?? FakeMenuViewModelDelegate()
        let databaseService = fakeDatabaseService ?? FakeDatabaseService()
        let vm = MenuViewModel(delegate: delegate, databaseService: databaseService)
        return MenuViewController(viewModel: vm)
    }
    
}
