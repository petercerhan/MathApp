//
//  ConceptIntroSceneTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
import iosMath
@testable import MathApp

class ConceptIntroSceneTests: XCTestCase {
    
    func test_constantRule_displaysConstantRuleDescription() {
        let conceptIntro = ConceptIntroLearningStep.createWithConcept(concept: Concept.constantRule)
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.conceptNameLabel.text, conceptIntro.userConcept.concept.name)
    }
    
    func test_tableViewDelegates_shouldBeSet() {
        let vc = composeSUT()
        
        vc.loadViewIfNeeded()
        
        XCTAssertNotNil(vc.tableView.dataSource)
    }
    
    func test_firstDetailCellFormula_shouldShowFormula() {
        var stubConcept = Concept.constantRule
        stubConcept.detailGlyphs = [FormulaConceptDetailGlyph.createStub()]
        let stubConceptIntro = ConceptIntroLearningStep.createWithConcept(concept: stubConcept)
        let vc = composeSUT(stubConceptIntro: stubConceptIntro)
        
        vc.loadViewIfNeeded()
        
        ConceptDetailFormulaTableViewCell.assertCellAtRow(0, inTable: vc.tableView, containsFormula: "x + y = z")
    }
    
    func test_nextButton_shouldRequestNext() {
        let mockDelegate = FakeConceptIntroViewModelDelegate()
        let vc = composeSUT(fakeDelegate: mockDelegate)
        
        vc.loadViewIfNeeded()
        vc.nextButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.next_callCount, 1)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(fakeDelegate: FakeConceptIntroViewModelDelegate? = nil, stubConceptIntro: ConceptIntroLearningStep? = nil) -> ConceptIntroViewController {
        let delegate = fakeDelegate ?? FakeConceptIntroViewModelDelegate()
        let conceptIntro = stubConceptIntro ?? ConceptIntroLearningStep.createWithConcept(concept: Concept.constantRule)
        let vm = ConceptIntroViewModelImpl(delegate: delegate, conceptIntro: conceptIntro)
        return ConceptIntroViewController(viewModel: vm)
    }
    
}
