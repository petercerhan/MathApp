//
//  NewMaterialTwoFocusStrategyTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class NewMaterialTwoFocusStrategyTests: XCTestCase {
    
    func test_bothScoresBelow5_shouldReturnExerciseFeedPackage() {
        let strategy = composeSUT(strength1: 1, score1: 0, strength2: 1, score2: 0)
        
        let package = strategy.getFeedPackage()
        
        XCTAssertEqual(package.feedPackageType, .exercises)
        XCTAssertGreaterThan(package.exercises.count, 0)
    }
    
    func test_1stScoreAbove5_shouldReturnLevelUp1stConcept() {
        let strategy = composeSUT(strength1: 1, score1: 6, strength2: 2, score2: 1)
        
        let package = strategy.getFeedPackage()
        
        XCTAssertEqual(package.feedPackageType, .levelUp)
        guard let levelUpItem = package.transitionItem as? LevelUpItem else {
            XCTFail("No level up item found")
            return
        }
        XCTAssertEqual(levelUpItem.concept.id, 1)
        XCTAssertEqual(levelUpItem.previousLevel, 1)
        XCTAssertEqual(levelUpItem.newLevel, 2)
    }
    
    func test_bothScoresAbove5_shouldReturnLevelUp1stConcept() {
        let strategy = composeSUT(strength1: 1, score1: 6, strength2: 2, score2: 6)
        
        let package = strategy.getFeedPackage()
        
        assertIsLevelUpPackage(package: package, conceptID: 1, initialLevel: 1)
    }
    
    func test_2ndScoreAbove5_shouldReturnLevelUp2ndConcept() {
        let strategy = composeSUT(strength1: 1, score1: 3, strength2: 1, score2: 6)
        
        let package = strategy.getFeedPackage()
        
        assertIsLevelUpPackage(package: package, conceptID: 2, initialLevel: 1)
    }
    
    //MARK: - SUT Composition
    
    func composeSUT(strength1: Int = 1, score1: Int = 0, strength2: Int = 1, score2: Int = 0) -> DefaultTwoFocusStrategy {
        let userConcept1 = UserConcept(id: 1, concept: Concept.constantRule, strength: strength1)
        let stubEnrichedUserConcept1 = EnrichedUserConcept(userConcept: userConcept1, statusCode: introductionCompleteCode, currentScore: score1)!
        let userConcept2 = UserConcept(id: 2, concept: Concept.linearRule, strength: strength2)
        let stubEnrichedUserConcept2 = EnrichedUserConcept(userConcept: userConcept2, statusCode: introductionCompleteCode, currentScore: score2)!
        return DefaultTwoFocusStrategy(exerciseSetCalculator: FakeExerciseSetCalculator(), enrichedUserConcept1: stubEnrichedUserConcept1, enrichedUserConcept2: stubEnrichedUserConcept2)
    }
    
    var introductionCompleteCode: Int {
        return EnrichedUserConcept.Status.introductionComplete.rawValue
    }
    
    //MARK: - Assertions
    
    func assertIsLevelUpPackage(package: FeedPackage, conceptID: Int, initialLevel: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(package.feedPackageType, .levelUp)
        guard let levelUpItem = package.transitionItem as? LevelUpItem else {
            XCTFail("No level up item found", file: file, line: line)
            return
        }
        XCTAssertEqual(levelUpItem.concept.id, conceptID, file: file, line: line)
        XCTAssertEqual(levelUpItem.previousLevel, initialLevel, file: file, line: line)
        XCTAssertEqual(levelUpItem.newLevel, initialLevel + 1, file: file, line: line)
    }
    
}


