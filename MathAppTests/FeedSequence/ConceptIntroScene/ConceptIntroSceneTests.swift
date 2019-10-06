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
        let conceptIntro = ConceptIntro(concept: Concept.constantRule)
        let vm = ConceptIntroViewModel(delegate: FakeConceptIntroViewModelDelegate(), conceptIntro: conceptIntro)
        let vc = ConceptIntroViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        
        XCTAssertEqual(vc.conceptNameLabel.text, conceptIntro.concept.name)
        XCTAssertEqual(vc.conceptDescriptionLabel.text, conceptIntro.concept.description)
        XCTAssertEqual(vc.ruleLatexLabel.latex, conceptIntro.concept.rule)
    }
    
    func test_nextButton_shouldRequestNext() {
        let conceptIntro = ConceptIntro(concept: Concept.constantRule)
        let mockDelegate = FakeConceptIntroViewModelDelegate()
        let vm = ConceptIntroViewModel(delegate: mockDelegate, conceptIntro: conceptIntro)
        let vc = ConceptIntroViewController(viewModel: vm)
        
        vc.loadViewIfNeeded()
        vc.nextButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockDelegate.next_callCount, 1)
    }
    
}
