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
    
    func test_sceneComposed_shouldRequestUserConceptsByChapter() {
        let mockUserConceptEDS = FakeUserConceptExternalDataService()
        let vc = composeSUT(fakeUserConceptEDS: mockUserConceptEDS)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(mockUserConceptEDS.list_chapterID_callCount, 1)
    }
    
    func test_oneConcept_shouldDisplayOneConcept() {
        let stubData = [UserConcept(id: 1, concept: Concept.constantRule, strength: 1)]
        let vc = composeSUT(stubUserConcepts: stubData)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.tableView.dataSource?.tableView(vc.tableView, numberOfRowsInSection: 0), 1)
        ConceptMapTableViewCell.assertCellAtRow(0, inTable: vc.tableView, containsConceptNamed: "Constant Rule", strength: 1)
    }
    
    func test_twoConcepts_shouldDisplayTwoConcepts() {
        let stubData = [UserConcept(id: 1, concept: Concept.constantRule, strength: 1),
                        UserConcept(id: 2, concept: Concept.linearRule, strength: 2)]
        let vc = composeSUT(stubUserConcepts: stubData)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.tableView.dataSource?.tableView(vc.tableView, numberOfRowsInSection: 0), 2)
        ConceptMapTableViewCell.assertCellAtRow(1, inTable: vc.tableView, containsConceptNamed: "Linear Rule", strength: 2)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeDelegate: ConceptMapViewModelDelegate? = nil,
                    fakeUserConceptEDS: FakeUserConceptExternalDataService? = nil,
                    stubUserConcepts: [UserConcept]? = nil) -> ConceptMapViewController
    {
        let delegate = fakeDelegate ?? FakeConceptMapViewModelDelegate()
        
        let userConceptEDS = fakeUserConceptEDS ?? FakeUserConceptExternalDataService()
        if let stubUserConcepts = stubUserConcepts {
            userConceptEDS.stubUserConcepts = stubUserConcepts
        }
        
        let userConcepts = stubUserConcepts ?? [UserConcept(id: 1, concept: Concept.constantRule, strength: 1)]
        let databaseService = FakeDatabaseService()
        databaseService.stubUserConcepts = userConcepts
        
        let vm = ConceptMapViewModel(delegate: delegate, databaseService: databaseService, userConceptEDS: userConceptEDS)
        return ConceptMapViewController(viewModel: vm)
    }
    
}
