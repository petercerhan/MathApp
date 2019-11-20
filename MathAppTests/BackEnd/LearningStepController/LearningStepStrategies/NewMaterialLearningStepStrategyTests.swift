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
        XCTAssertEqual(practiceStep.userConcept.conceptID, 2)
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
        XCTAssertEqual(practiceStep.userConcept.conceptID, 2)
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
    
    func test_scenario6_shouldReturnTransitionWithConceptGroupItem() {
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(2, 2, 2, 2, 2))
        
        let learningStep = strategy.nextLearningStep()
        
        guard let transitionStep = learningStep as? TransitionLearningStep else {
            XCTFail("Learning step is not transition learning step. Is type \(learningStep.self)")
            return
        }
        guard let groupCompleteItem = transitionStep.transitionItems.first as? GroupCompleteTransitionItem else {
            XCTFail("Did not find group complete transition step")
            return
        }
        XCTAssertEqual(groupCompleteItem.completedConceptGroup.id, 1)
    }
    
    func test_scenario6_shouldSetConceptGroupComplete() {
        let mockUserConceptGroupRepository = FakeUserConceptGroupRepository()
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(2, 2, 2, 2, 2), fakeUserConceptGroupRepository: mockUserConceptGroupRepository)
        
        let _ = strategy.nextLearningStep()
        
        XCTAssertEqual(mockUserConceptGroupRepository.set_callCount, 1)
        XCTAssertEqual(mockUserConceptGroupRepository.set_id.first, 1)
        XCTAssertEqual(mockUserConceptGroupRepository.set_fields.first, ["completed": "1"])
    }
    
    func test_scenario6_shouldUpdateNewMaterialState() {
        let mockNewMaterialStateRepository = FakeNewMaterialStateRepository()
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(2, 2, 2, 2, 2), conceptGroups: conceptGroups_1000, fakeNewMaterialStateRepository: mockNewMaterialStateRepository)
        
        let _ = strategy.nextLearningStep()
        
        XCTAssertEqual(mockNewMaterialStateRepository.resetForNewConceptGroup_callCount, 1)
        XCTAssertEqual(mockNewMaterialStateRepository.resetForNewConceptGroup_conceptGroupID.first, 2)
    }
    
    
    //MARK: - Transition Concept Group Scenarios
    
    func test_transitionScenario1_shouldTransitionToConcept2() {
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(2, 2, 2, 2, 2), focus1ID: 1, focus2ID: 0, conceptGroups: conceptGroups_1000)
        
        let learningStep = strategy.nextLearningStep()
        
        guard
            let transitionStep = learningStep as? TransitionLearningStep,
            let groupCompleteItem = transitionStep.transitionItems.first as? GroupCompleteTransitionItem
        else {
            XCTFail("Did not find group complete transition item")
            return
        }
        XCTAssertEqual(groupCompleteItem.nextConceptGroup.id, 2)
    }
    
    func test_transitionScenario2_shouldTransitionFromConcept2ToConcept3() {
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(2, 2, 2, 2, 2), currentGroup: 2, conceptGroups: conceptGroups_1000)
        
        let learningStep = strategy.nextLearningStep()
        
        guard
            let transitionStep = learningStep as? TransitionLearningStep,
            let groupCompleteItem = transitionStep.transitionItems.first as? GroupCompleteTransitionItem
        else {
            XCTFail("Did not find group complete transition item")
            return
        }
        XCTAssertEqual(groupCompleteItem.completedConceptGroup.id, 2)
        XCTAssertEqual(groupCompleteItem.nextConceptGroup.id, 3)
    }
    
    func test_transitionScenario3_shouldTransitionFromConcept2ToConcept4() {
        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(2, 2, 2, 2, 2), currentGroup: 2, conceptGroups: conceptGroups_1110)
        
        let learningStep = strategy.nextLearningStep()
        
        guard
            let transitionStep = learningStep as? TransitionLearningStep,
            let groupCompleteItem = transitionStep.transitionItems.first as? GroupCompleteTransitionItem
        else {
            XCTFail("Did not find group complete transition item")
            return
        }
        XCTAssertEqual(groupCompleteItem.completedConceptGroup.id, 2)
        XCTAssertEqual(groupCompleteItem.nextConceptGroup.id, 4)
    }
    
    
    
//    func test_scenario6_shouldResetNewMaterialState() {
//        let mockNewMaterialStateRepository = FakeNewMaterialStateRepository()
//        let strategy = composeSUT(stubUserConcepts: userConceptsWithLevels(2, 2, 2, 2, 2), focus1ID: 1, focus2ID: 0, fakeNewMaterialStateRepository: mockNewMaterialStateRepository)
//
//        let _ = strategy.nextLearningStep()
//
//        XCTAssertEqual(mockNewMaterialStateRepository.reset_callCount, 1)
//    }
    
    
    
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
                    currentGroup: Int = 1,
                    focus1ID: Int = 1,
                    focus2ID: Int = 0,
                    conceptGroups: [UserConceptGroup]? = nil,
                    fakeNewMaterialStateRepository: FakeNewMaterialStateRepository? = nil,
                    fakeUserRepository: FakeUserRepository? = nil,
                    fakeUserConceptGroupRepository: FakeUserConceptGroupRepository? = nil) -> NewMaterialLearningStepStrategy
    {
        let stubUserConceptRepository = FakeUserConceptRepository()
        stubUserConceptRepository.list_stubUserConcepts = stubUserConcepts
        
        let newMaterialStateRepository = fakeNewMaterialStateRepository ?? FakeNewMaterialStateRepository()
        newMaterialStateRepository.stubNewMaterialState = NewMaterialState.createStub(conceptGroupID: currentGroup, focusConcept1ID: focus1ID, focusConcept2ID: focus2ID)
        
        let userRepository = fakeUserRepository ?? FakeUserRepository()
        
        let userConceptGroupRepository = fakeUserConceptGroupRepository ?? FakeUserConceptGroupRepository()
        userConceptGroupRepository.list_stubs = conceptGroups ?? conceptGroups_1000
        
        return NewMaterialLearningStepStrategy(userConceptRepository: stubUserConceptRepository,
                                               newMaterialStateRepository: newMaterialStateRepository,
                                               userRepository: userRepository,
                                               userConceptGroupRepository: userConceptGroupRepository,
                                               conceptDetailGlyphRepository: FakeConceptDetailGlyphRepository())
    }
    
    func userConceptsWithLevels(_ strength1: Int, _ strength2: Int, _ strength3: Int, _ strength4: Int, _ strength5: Int) -> [UserConcept] {
        return [UserConcept.createStub(id: 1, concept: Concept.constantRule, strength: strength1),
                UserConcept.createStub(id: 2, concept: Concept.linearRule, strength: strength2),
                UserConcept.createStub(id: 3, concept: Concept.powerRule, strength: strength3),
                UserConcept.createStub(id: 4, concept: Concept.sumRule, strength: strength4),
                UserConcept.createStub(id: 5, concept: Concept.differenceRule, strength: strength5)]
    }
    
    //MARK: - Stubs
    
    private let conceptGroups_1000 = [UserConceptGroup.createStub(conceptGroupID: 1, completed: true),
                                      UserConceptGroup.createStub(conceptGroupID: 2, completed: false),
                                      UserConceptGroup.createStub(conceptGroupID: 3, completed: false),
                                      UserConceptGroup.createStub(conceptGroupID: 4, completed: false)]
                                      
    private let conceptGroups_1110 = [UserConceptGroup.createStub(conceptGroupID: 1, completed: true),
                                        UserConceptGroup.createStub(conceptGroupID: 2, completed: true),
                                        UserConceptGroup.createStub(conceptGroupID: 3, completed: true),
                                        UserConceptGroup.createStub(conceptGroupID: 4, completed: false)]
    
}
