//
//  NewMaterialLevelUpStrategy.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/18/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class NewMaterialLevelUpStrategyTests: XCTestCase {
    
    func test_shouldIncrementConceptLevel() {
        let mockDatabaseService = FakeDatabaseService()
        let strategy = composeSUT(fakeDatabaseService: mockDatabaseService, levelUpConceptStrength: 0, stubLevelUpConceptStatusCode: inProgressCode)
        
        let _ = strategy.getFeedPackage()
        
        XCTAssertEqual(mockDatabaseService.incrementStrengthForUserConcept_callCount, 1)
        XCTAssertEqual(mockDatabaseService.incrementStrengthForUserConcept_conceptID.first, 1)
    }
    
    func test_priorLevel0_shouldSetConceptStatusComplete() {
        let mockDatabaseService = FakeDatabaseService()
        let strategy = composeSUT(fakeDatabaseService: mockDatabaseService, levelUpConceptStrength: 0, stubLevelUpConceptStatusCode: inProgressCode)
        
        let _ = strategy.getFeedPackage()
        
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_callCount, 1)
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_status.first, completeCode)
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_id.first, 1)
    }
    
    func test_oneFocus_unseenInFamily_shouldReturnConceptIntroForFirstUnseenConcept() {
        let stubFamilyConcepts = family_concepts3and4Unseen
        let strategy = composeSUT(stubFamilyUserConcepts: stubFamilyConcepts)
        
        let package = strategy.getFeedPackage()
        
        XCTAssertEqual(package.feedPackageType, .conceptIntro)
        guard let conceptIntro = package.transitionItem as? ConceptIntro else {
            XCTFail("transition item is not concept intro")
            return
        }
        XCTAssertEqual(conceptIntro.concept.id, 3)
        XCTAssertEqual(package.exercises.count, 3)
    }
    
    func test_oneFocus_unseenInFamily_shouldUpdateFocusToIntroConcept() {
        let mockDatabaseService = FakeDatabaseService()
        let strategy = composeSUT(fakeDatabaseService: mockDatabaseService, stubFamilyUserConcepts: family_concepts3and4Unseen)
        
        let _ = strategy.getFeedPackage()
        
        XCTAssertEqual(mockDatabaseService.setFocusConcepts_callCount, 1)
        XCTAssertEqual(mockDatabaseService.setFocusConcepts_concept1.first, 3)
        XCTAssertEqual(mockDatabaseService.setFocusConcepts_concept2.first, 0)
    }
    
    
    //MARK: - SUT Composition
    
    private func composeSUT(fakeDatabaseService: FakeDatabaseService? = nil,
                            levelUpConceptStrength: Int = 1,
                            stubLevelUpConceptStatusCode: Int? = nil,
                            stubFamilyUserConcepts: [EnrichedUserConcept]? = nil) -> NewMaterialLevelUpStrategy
    {
        let databaseService = fakeDatabaseService ?? FakeDatabaseService()
        let levelUpConceptStatusCode = stubLevelUpConceptStatusCode ?? completeCode
        
        let levelUpConcept = UserConcept(id: 1, concept: Concept.constantRule, strength: levelUpConceptStrength)
        let levelUpEnrichedConcept = EnrichedUserConcept(userConcept: levelUpConcept, statusCode: levelUpConceptStatusCode, currentScore: 5)!
        
        let familyUserConcepts = stubFamilyUserConcepts ?? family_concepts3and4Unseen
        
        return NewMaterialLevelUpStrategy(databaseService: databaseService,
                                          exerciseSetCalculator: FakeExerciseSetCalculator(),
                                          levelUpUserConcept: levelUpEnrichedConcept,
                                          familyUserConcepts: familyUserConcepts)
    }
    
    //MARK: - Helpers
    
    var family_concepts3and4Unseen: [EnrichedUserConcept] {
        let concept1 = EnrichedUserConcept.createStub(conceptID: 1, status: .introductionComplete)
        let concept2 = EnrichedUserConcept.createStub(conceptID: 2, status: .introductionComplete)
        let concept3 = EnrichedUserConcept.createStub(conceptID: 3, status: .unseen)
        let concept4 = EnrichedUserConcept.createStub(conceptID: 4, status: .unseen)
        let concept5 = EnrichedUserConcept.createStub(conceptID: 5, status: .introductionComplete)
        return [concept1, concept2, concept3, concept4, concept5]
    }
    
    var inProgressCode: Int {
        return EnrichedUserConcept.Status.introductionInProgress.rawValue
    }
    
    var completeCode: Int {
        return EnrichedUserConcept.Status.introductionComplete.rawValue
    }
    
}
