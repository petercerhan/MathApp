//
//  ConceptMapSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

class ConceptMapSceneTests: XCTestCase {
    
    func test_backPressed_shouldRequestBack() {
        let mockDelegate = FakeConceptMapViewModelDelegate()
        let vc = composeSUT(fakeDelegate: mockDelegate)
        
        vc.loadViewIfNeeded()
        vc.backButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.back_callCount, 1)
    }
    
    func test_tableViewDelegates_shouldBeSet() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        
        XCTAssertNotNil(vc.tableView.dataSource)
    }
    
    func test_oneConcept_shouldDisplayOneConcept() {
        let stubData = [UserConcept(id: 1, concept: Concept.constantRule, strength: 1)]
        let vc = composeSUT(stubUserConcepts: stubData)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.tableView.dataSource?.tableView(vc.tableView, numberOfRowsInSection: 0), 1)
        guard let cell = vc.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ConceptMapTableViewCell else {
            XCTFail("Could not get cell")
            return
        }
        XCTAssertEqual(cell.nameLabel.text, "Constant Rule")
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeDelegate: ConceptMapViewModelDelegate? = nil, stubUserConcepts: [UserConcept]? = nil) -> ConceptMapViewController {
        let delegate = fakeDelegate ?? FakeConceptMapViewModelDelegate()
        let userConcepts = stubUserConcepts ?? [UserConcept(id: 1, concept: Concept.constantRule, strength: 1)]
        let databaseService = FakeDatabaseService()
        databaseService.stubUserConcepts = userConcepts
        let vm = ConceptMapViewModel(delegate: delegate, databaseService: databaseService)
        return ConceptMapViewController(viewModel: vm)
    }
    
}
