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
        let userConcept1 = UserConcept(id: 1, concept: Concept.constantRule, strength: 0)
        let stubEnrichedUserConcept1 = EnrichedUserConcept(userConcept: userConcept1, statusCode: inProgressCode, currentScore: 5)!
        let strategy = NewMaterialLevelUpStrategy(databaseService: mockDatabaseService, levelUpUserConcept: stubEnrichedUserConcept1)
        
        let _ = strategy.getFeedPackage()
        
        XCTAssertEqual(mockDatabaseService.incrementStrengthForUserConcept_callCount, 1)
        XCTAssertEqual(mockDatabaseService.incrementStrengthForUserConcept_conceptID.first, 1)
    }
    
    func test_priorLevel0_shouldSetConceptStatusComplete() {
        let mockDatabaseService = FakeDatabaseService()
        let userConcept1 = UserConcept(id: 1, concept: Concept.constantRule, strength: 0)
        let stubEnrichedUserConcept1 = EnrichedUserConcept(userConcept: userConcept1, statusCode: inProgressCode, currentScore: 5)!
        let strategy = NewMaterialLevelUpStrategy(databaseService: mockDatabaseService, levelUpUserConcept: stubEnrichedUserConcept1)
        
        let _ = strategy.getFeedPackage()
        
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_callCount, 1)
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_status.first, completeCode)
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_id.first, 1)
    }
    
    
    
    
    
    var inProgressCode: Int {
        return EnrichedUserConcept.Status.introductionInProgress.rawValue
    }
    
    var completeCode: Int {
        return EnrichedUserConcept.Status.introductionComplete.rawValue
    }
    
}
