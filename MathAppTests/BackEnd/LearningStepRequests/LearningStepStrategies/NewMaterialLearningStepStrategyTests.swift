//
//  NewMaterialLearningStepStrategyTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class NewMaterialLearningStepStrategyTests: XCTestCase {
    
    func test_userConceptLevels_0_0_0_0_0_shouldReturnConceptIntro1() {
        let stubUserConcepts = userConceptsWithLevels(0, 0, 0, 0, 0)
        let strategy = NewMaterialLearningStepStrategy()
        
        let learningStep = strategy.nextLearningStep()
        
        guard let conceptIntro = learningStep as? ConceptIntroLearningStep else {
            XCTFail("Learning step is not concept intro")
            return
        }
        XCTAssertEqual(conceptIntro.conceptID, 1)
    }
    
    func test_userConceptLevels_1_0_0_0_0_shouldReturnConceptIntro2() {
        let stubUserConcepts = userConceptsWithLevels(1, 0, 0, 0, 0)
        
        
        
        
    }
    
    func userConceptsWithLevels(_ strength1: Int, _ strength2: Int, _ strength3: Int, _ strength4: Int, _ strength5: Int) -> [UserConcept] {
        return [UserConcept.createStub(id: 1, concept: Concept.constantRule, strength: strength1),
                UserConcept.createStub(id: 2, concept: Concept.linearRule, strength: strength2),
                UserConcept.createStub(id: 3, concept: Concept.powerRule, strength: strength3),
                UserConcept.createStub(id: 4, concept: Concept.sumRule, strength: strength4),
                UserConcept.createStub(id: 5, concept: Concept.differenceRule, strength: strength5)]
    }
    
}
