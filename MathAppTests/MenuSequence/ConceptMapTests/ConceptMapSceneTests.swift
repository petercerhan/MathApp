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
    
    func test_sceneComposed_shouldRequestUserConceptGroupsByChapter() {
        let mockUserConceptGroupEDS = FakeUserConceptGroupExternalDataService()
        let vc = composeSUT(fakeUserConceptGroupEDS: mockUserConceptGroupEDS)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(mockUserConceptGroupEDS.listByChapter_callCount, 1)
    }
    
    func test_oneConceptOneGroup_shouldDisplayOneConceptOneGroup() {
        let stubConcepts = [UserConcept(id: 1, concept: Concept.constantRule, strength: 1)]
        let stubGroups = [UserConceptGroup.createStub(id: 1, conceptGroupID: 1, completed: false)]
        let vc = composeSUT(stubUserConcepts: stubConcepts, stubUserConceptGroups: stubGroups)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.tableView.dataSource?.tableView(vc.tableView, numberOfRowsInSection: 0), 2)
        ConceptGroupTableViewCell.assertCellAtRow(0, inTable: vc.tableView, showsName: "Stub Concept Group")
        ConceptTableViewCell.assertCellAtRow(1, inTable: vc.tableView, showsName: "Constant Rule")
    }
    
    func test_twoConceptsOneGroup_shouldDisplayTwoConceptsOneGroup() {
        let stubConcepts = [UserConcept(id: 1, concept: Concept.constantRule, strength: 1),
                            UserConcept(id: 2, concept: Concept.linearRule, strength: 2)]
        let stubGroups = [UserConceptGroup.createStub(id: 1, conceptGroupID: 1, completed: false)]
        let vc = composeSUT(stubUserConcepts: stubConcepts, stubUserConceptGroups: stubGroups)

        vc.loadViewIfNeeded()

        XCTAssertEqual(vc.tableView.dataSource?.tableView(vc.tableView, numberOfRowsInSection: 0), 3)
        ConceptGroupTableViewCell.assertCellAtRow(0, inTable: vc.tableView, showsName: "Stub Concept Group")
        ConceptTableViewCell.assertCellAtRow(1, inTable: vc.tableView, showsName: "Constant Rule")
        ConceptTableViewCell.assertCellAtRow(2, inTable: vc.tableView, showsName: "Linear Rule")
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeDelegate: ConceptMapViewModelDelegate? = nil,
                    fakeUserConceptEDS: FakeUserConceptExternalDataService? = nil,
                    fakeUserConceptGroupEDS: FakeUserConceptGroupExternalDataService? = nil,
                    stubUserConcepts: [UserConcept]? = nil,
                    stubUserConceptGroups: [UserConceptGroup] = []) -> ConceptMapViewController
    {
        let delegate = fakeDelegate ?? FakeConceptMapViewModelDelegate()
        
        let userConceptEDS = fakeUserConceptEDS ?? FakeUserConceptExternalDataService()
        let userConcepts = stubUserConcepts ?? [UserConcept(id: 1, concept: Concept.constantRule, strength: 1)]
        userConceptEDS.stubUserConcepts = userConcepts
        
        let userConceptGroupEDS = fakeUserConceptGroupEDS ?? FakeUserConceptGroupExternalDataService()
        userConceptGroupEDS.stubUserConceptGroups = stubUserConceptGroups
        
        let vm = ConceptMapViewModel(delegate: delegate,
                                     userConceptEDS: userConceptEDS,
                                     userConceptGroupEDS: userConceptGroupEDS)
        return ConceptMapViewController(viewModel: vm)
    }
    
}
