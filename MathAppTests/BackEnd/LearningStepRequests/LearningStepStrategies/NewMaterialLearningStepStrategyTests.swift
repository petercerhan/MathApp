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
    
    func test_scenario1_shouldReturnConceptIntro1() {
        let stubUserConcepts = userConceptsWithLevels(0, 0, 0, 0, 0)
        let strategy = composeSUT(stubUserConcepts: stubUserConcepts, focus1ID: 0, focus2ID: 0)
        
        let learningStep = strategy.nextLearningStep()
        
        guard let conceptIntro = learningStep as? ConceptIntroLearningStep else {
            XCTFail("Learning step is not concept intro")
            return
        }
        XCTAssertEqual(conceptIntro.conceptID, 1)
    }
    
    func test_scenario2_shouldReturnConceptIntro2() {
        let stubUserConcepts = userConceptsWithLevels(1, 0, 0, 0, 0)
        let strategy = composeSUT(stubUserConcepts: stubUserConcepts, focus1ID: 0, focus2ID: 0)
        
        let learningStep = strategy.nextLearningStep()
        
        guard let conceptIntro = learningStep as? ConceptIntroLearningStep else {
            XCTFail("Learning step is not concept intro")
            return
        }
        XCTAssertEqual(conceptIntro.conceptID, 2)
    }
    
    func test_scenario3_shouldReturnPracticeFocus2() {
        let stubUserConcepts = userConceptsWithLevels(2, 1, 0, 0, 0)
        let strategy = composeSUT(stubUserConcepts: stubUserConcepts, focus1ID: 1, focus2ID: 2)
        
        let learningStep = strategy.nextLearningStep()
        
        guard let practiceStep = learningStep as? PracticeOneConceptLearningStep else {
            XCTFail("Learning step is not practice one concept. Is type \(learningStep.self)")
            return
        }
        XCTAssertEqual(practiceStep.conceptID, 2)
    }
    
    func test_scenario4_shouldReturnPracticeFocus2() {
        let stubUserConcepts = userConceptsWithLevels(2, 1, 1, 0, 0)
        let strategy = composeSUT(stubUserConcepts: stubUserConcepts, focus1ID: 1, focus2ID: 2)
        
        let learningStep = strategy.nextLearningStep()
        
        guard let practiceStep = learningStep as? PracticeOneConceptLearningStep else {
            XCTFail("Learning step is not practice one concept. Is type \(learningStep.self)")
            return
        }
        XCTAssertEqual(practiceStep.conceptID, 2)
    }
    
    func test_scenario5_shouldReturnPracticeFocus1And2() {
        let stubUserConcepts = userConceptsWithLevels(1, 1, 0, 0, 0)
        let strategy = composeSUT(stubUserConcepts: stubUserConcepts, focus1ID: 2, focus2ID: 0)
        
        let learningStep = strategy.nextLearningStep()
        
        guard let practiceStep = learningStep as? PracticeTwoConceptsLearningStep else {
            XCTFail("Learning step is not practice two concepts. Is type \(learningStep.self)")
            return
        }
        XCTAssertEqual(practiceStep.concept1ID, 1)
        XCTAssertEqual(practiceStep.concept2ID, 2)
    }
    
//    func test_scenario6_shouldReturnGeneralPracticeStart() {
//        let stubUserConcepts = userConceptsWithLevels(2, 2, 2, 2, 2)
//        let strategy = composeSUT(stubUserConcepts: stubUserConcepts, focus1ID: 1, focus2ID: 0)
//        
//        let learningStep = strategy.nextLearningStep()
//        
//        
//        
//    }
    
    
    
    //MARK: - Cross Check Scenarios
    
    
    
    
    //MARK: - SUT Composition
    
    func composeSUT(stubUserConcepts: [UserConcept], focus1ID: Int, focus2ID: Int) -> NewMaterialLearningStepStrategy {
        let stubUserConceptRepository = FakeUserConceptRepository()
        stubUserConceptRepository.list_stubUserConcepts = stubUserConcepts
        
        let newMaterialStateRepository = FakeNewMaterialStateRepository()
        newMaterialStateRepository.stubNewMaterialState = NewMaterialState.createStub(focusConcept1ID: focus1ID, focusConcept2ID: focus2ID)
        
        return NewMaterialLearningStepStrategy(userConceptRepository: stubUserConceptRepository, newMaterialStateRepository: newMaterialStateRepository)
    }
    
    func userConceptsWithLevels(_ strength1: Int, _ strength2: Int, _ strength3: Int, _ strength4: Int, _ strength5: Int) -> [UserConcept] {
        return [UserConcept.createStub(id: 1, concept: Concept.constantRule, strength: strength1),
                UserConcept.createStub(id: 2, concept: Concept.linearRule, strength: strength2),
                UserConcept.createStub(id: 3, concept: Concept.powerRule, strength: strength3),
                UserConcept.createStub(id: 4, concept: Concept.sumRule, strength: strength4),
                UserConcept.createStub(id: 5, concept: Concept.differenceRule, strength: strength5)]
    }
    
}
