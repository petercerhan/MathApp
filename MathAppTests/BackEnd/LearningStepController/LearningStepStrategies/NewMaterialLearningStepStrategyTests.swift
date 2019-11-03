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
        
        guard let conceptIntroStep = learningStep as? ConceptIntroLearningStep else {
            XCTFail("Learning step is not concept intro")
            return
        }
        XCTAssertEqual(conceptIntroStep.userConcept.concept.id, 1)
    }
    
    func test_scenario1_shouldSetFocusAs10() {
        let mockNewMaterialStateRepository = FakeNewMaterialStateRepository()
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(0, 0, 0, 0, 0), focus1ID: 0, focus2ID: 0, fakeNewMaterialStateRepository: mockNewMaterialStateRepository)
        
        let _ = strategy.nextLearningStep()
        
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_callCount, 1)
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_concept1ID.first, 1)
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_concept2ID.first, 0)
    }
    
    func test_scenario2_shouldReturnConceptIntro2() {
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(1, 0, 0, 0, 0), focus1ID: 0, focus2ID: 0)
        
        let learningStep = strategy.nextLearningStep()
        
        guard let conceptIntroStep = learningStep as? ConceptIntroLearningStep else {
            XCTFail("Learning step is not concept intro")
            return
        }
        XCTAssertEqual(conceptIntroStep.userConcept.concept.id, 2)
    }
    
    func test_scenario2_shouldSetFocusAs20() {
        let mockNewMaterialStateRepository = FakeNewMaterialStateRepository()
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(1, 0, 0, 0, 0), focus1ID: 0, focus2ID: 0, fakeNewMaterialStateRepository: mockNewMaterialStateRepository)
        
        let _ = strategy.nextLearningStep()
        
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_callCount, 1)
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_concept1ID.first, 2)
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_concept2ID.first, 0)
    }
    
    func test_scenario2b_shouldReturnConceptIntro2() {
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(1, 0, 0, 0, 0), focus1ID: 1, focus2ID: 0)
        
        let learningStep = strategy.nextLearningStep()
        
        guard let conceptIntroStep = learningStep as? ConceptIntroLearningStep else {
            XCTFail("Learning step is not concept intro")
            return
        }
        XCTAssertEqual(conceptIntroStep.userConcept.concept.id, 2)
    }
    
    //Continue second concept practice after single level up (remove?)
    func test_scenario3_shouldReturnPracticeConcept2() {
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(2, 1, 0, 0, 0), focus1ID: 1, focus2ID: 2)
        
        let learningStep = strategy.nextLearningStep()
        
        guard let practiceStep = learningStep as? PracticeOneConceptLearningStep else {
            XCTFail("Learning step is not practice one concept. Is type \(learningStep.self)")
            return
        }
        XCTAssertEqual(practiceStep.conceptID, 2)
    }
    
    func test_scenario3_shouldSetFocus20() {
        let mockNewMaterialStateRepository = FakeNewMaterialStateRepository()
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(2, 1, 0, 0, 0), focus1ID: 1, focus2ID: 2, fakeNewMaterialStateRepository: mockNewMaterialStateRepository)
        
        let _ = strategy.nextLearningStep()
        
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_callCount, 1)
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_concept1ID.first, 2)
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_concept2ID.first, 0)
    }
    
    func test_scenario4_shouldReturnPracticeConcept2() {
        let stubUserConcepts = userConceptsWithLevels(2, 1, 1, 0, 0)
        let strategy = composeSUT(stubUserConcepts: stubUserConcepts, focus1ID: 1, focus2ID: 2)
        
        let learningStep = strategy.nextLearningStep()
        
        guard let practiceStep = learningStep as? PracticeOneConceptLearningStep else {
            XCTFail("Learning step is not practice one concept. Is type \(learningStep.self)")
            return
        }
        XCTAssertEqual(practiceStep.conceptID, 2)
    }
    
    func test_scenario4_shouldSetFocus20() {
        let mockNewMaterialStateRepository = FakeNewMaterialStateRepository()
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(2, 1, 1, 0, 0), focus1ID: 1, focus2ID: 2, fakeNewMaterialStateRepository: mockNewMaterialStateRepository)
        
        let _ = strategy.nextLearningStep()
        
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_callCount, 1)
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_concept1ID.first, 2)
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_concept2ID.first, 0)
    }
    
    func test_scenario5_shouldReturnPracticeFocus1And2() {
        let stubUserConcepts = userConceptsWithLevels(1, 1, 0, 0, 0)
        let strategy = composeSUT(stubUserConcepts: stubUserConcepts, focus1ID: 2, focus2ID: 0)
        
        let learningStep = strategy.nextLearningStep()
        
        guard let practiceStep = learningStep as? PracticeTwoConceptsLearningStep else {
            XCTFail("Learning step is not practice two concepts. Is type \(learningStep.self)")
            return
        }
        XCTAssertEqual(practiceStep.userConcept1.conceptID, 1)
        XCTAssertEqual(practiceStep.userConcept2.conceptID, 2)
    }
    
    func test_scenario5_shouldSetFocus12() {
        let mockNewMaterialStateRepository = FakeNewMaterialStateRepository()
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(1, 1, 0, 0, 0), focus1ID: 2, focus2ID: 0, fakeNewMaterialStateRepository: mockNewMaterialStateRepository)
        
        let _ = strategy.nextLearningStep()
        
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_callCount, 1)
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_concept1ID.first, 1)
        XCTAssertEqual(mockNewMaterialStateRepository.setFocus_concept2ID.first, 2)
    }
    
    func test_scenario6_shouldReturnPracticeFamilyStart() {
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(2, 2, 2, 2, 2), focus1ID: 1, focus2ID: 0)
        
        let learningStep = strategy.nextLearningStep()
        
        guard let _ = learningStep as? PracticeFamilyLearningStep else {
            XCTFail("Learning step is not practice family. Is type \(learningStep.self)")
            return
        }
    }
    
    func test_scenario6_shouldResetNewMaterialState() {
        let mockNewMaterialStateRepository = FakeNewMaterialStateRepository()
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(2, 2, 2, 2, 2), focus1ID: 1, focus2ID: 0, fakeNewMaterialStateRepository: mockNewMaterialStateRepository)
        
        let _ = strategy.nextLearningStep()
        
        XCTAssertEqual(mockNewMaterialStateRepository.reset_callCount, 1)
    }
    
    func test_scenario6_shouldSetLearningStrategyPracticeFamily() {
        let mockUserRepository = FakeUserRepository()
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(2, 2, 2, 2, 2), focus1ID: 1, focus2ID: 0, fakeUserRepository: mockUserRepository)
        
        let _ = strategy.nextLearningStep()
        
        XCTAssertEqual(mockUserRepository.setLearningStrategy_callCount, 1)
        XCTAssertEqual(mockUserRepository.setLearningStrategy_strategy.first, .practiceFamily)
    }
    
    func test_scenario7_shouldReturnPracticeFocus1And2() {
        let stubUserConcepts = userConceptsWithLevels(1, 1, 0, 0, 0)
        let strategy = composeSUT(stubUserConcepts: stubUserConcepts, focus1ID: 1, focus2ID: 2)
        
        let learningStep = strategy.nextLearningStep()
        
        guard let practiceStep = learningStep as? PracticeTwoConceptsLearningStep else {
            XCTFail("Learning step is not practice two concepts. Is type \(learningStep.self)")
            return
        }
        XCTAssertEqual(practiceStep.userConcept1.conceptID, 1)
        XCTAssertEqual(practiceStep.userConcept2.conceptID, 2)
    }
    
    //MARK: - Cross Check Scenarios
    
    
    
    
    //MARK: - SUT Composition
    
    func composeSUT(stubUserConcepts: [UserConcept],
                    focus1ID: Int,
                    focus2ID: Int,
                    fakeNewMaterialStateRepository: FakeNewMaterialStateRepository? = nil,
                    fakeUserRepository: FakeUserRepository? = nil) -> NewMaterialLearningStepStrategy
    {
        let stubUserConceptRepository = FakeUserConceptRepository()
        stubUserConceptRepository.list_stubUserConcepts = stubUserConcepts
        
        let newMaterialStateRepository = fakeNewMaterialStateRepository ?? FakeNewMaterialStateRepository()
        newMaterialStateRepository.stubNewMaterialState = NewMaterialState.createStub(focusConcept1ID: focus1ID, focusConcept2ID: focus2ID)
        
        let userRepository = fakeUserRepository ?? FakeUserRepository()
        
        return NewMaterialLearningStepStrategy(userConceptRepository: stubUserConceptRepository,
                                               newMaterialStateRepository: newMaterialStateRepository,
                                               userRepository: userRepository)
    }
    
    func userConceptsWithLevels(_ strength1: Int, _ strength2: Int, _ strength3: Int, _ strength4: Int, _ strength5: Int) -> [UserConcept] {
        return [UserConcept.createStub(id: 1, concept: Concept.constantRule, strength: strength1),
                UserConcept.createStub(id: 2, concept: Concept.linearRule, strength: strength2),
                UserConcept.createStub(id: 3, concept: Concept.powerRule, strength: strength3),
                UserConcept.createStub(id: 4, concept: Concept.sumRule, strength: strength4),
                UserConcept.createStub(id: 5, concept: Concept.differenceRule, strength: strength5)]
    }
    
}
