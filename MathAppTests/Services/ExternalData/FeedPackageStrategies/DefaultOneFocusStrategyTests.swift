//
//  DefaultStandardFeedPackageStrategyTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/8/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class DefaultOneFocusStrategyTests: XCTestCase {
        
    func test_level0_unseen_shouldReturnConceptIntroPackage() {
        let strategy = composeSUT(stubStatusCode: unseenCode)
        
        let package = strategy.getFeedPackage()
        
        XCTAssertEqual(package.feedPackageType, .conceptIntro)
        guard let conceptIntro = package.transitionItem as? ConceptIntro else {
            XCTFail("no concept intro item")
            return
        }
        XCTAssertEqual(conceptIntro.concept.id, 2)
    }
    
    func test_level0_inProgress_scoreBelow5_shouldReturnExercisesPackage() {
        let strategy = composeSUT(stubStatusCode: introductionInProgressCode, stubCurrentScore: 3)
        
        let package = strategy.getFeedPackage()
        
        XCTAssertEqual(package.feedPackageType, .exercises)
        XCTAssertGreaterThan(package.exercises.count, 0)
    }
    
    func test_level0_inProgress_score5_shouldReturnLevelUpPackage() {
        let strategy = composeSUT(stubStatusCode: introductionInProgressCode, stubCurrentScore: 5)

        let package = strategy.getFeedPackage()
        
        XCTAssertEqual(package.feedPackageType, .levelUp)
        guard let levelUpItem = package.transitionItem as? LevelUpItem else {
            XCTFail("No level up item found")
            return
        }
        XCTAssertEqual(levelUpItem.concept.id, 2)
        XCTAssertEqual(levelUpItem.previousLevel, 0)
        XCTAssertEqual(levelUpItem.newLevel, 1)
    }
    
    func test_levelAbove0Below3_scoreBelow5_shouldReturnExercisesPackage() {
        let strategy = composeSUT(stubCurrentScore: 1, stubLevel: 1)

        let package = strategy.getFeedPackage()

        XCTAssertEqual(package.feedPackageType, .exercises)
        XCTAssertGreaterThan(package.exercises.count, 0)
    }
    
    func test_levelAbove0Below3_score5_shouldReturnLevelUpPackage() {
        let strategy = composeSUT(stubCurrentScore: 5, stubLevel: 2)

        let package = strategy.getFeedPackage()
        
        XCTAssertEqual(package.feedPackageType, .levelUp)
        guard let levelUpItem = package.transitionItem as? LevelUpItem else {
            XCTFail("No level up item found")
            return
        }
        XCTAssertEqual(levelUpItem.concept.id, 2)
        XCTAssertEqual(levelUpItem.previousLevel, 2)
        XCTAssertEqual(levelUpItem.newLevel, 3)
    }
    
    
    
    
    
    
    
    //MARK: - Compose SUT
    
    private func composeSUT(stubStatusCode: Int? = nil, stubCurrentScore: Int? = nil, stubLevel: Int = 0) -> DefaultOneFocusStrategy {
        let statusCode = stubStatusCode ?? introductionCompleteCode
        let currentScore = stubCurrentScore ?? 0
        
        let userConcept = UserConcept(id: 2, concept: Concept.linearRule, strength: stubLevel)
        let stubEnrichedUserConcept = EnrichedUserConcept(userConcept: userConcept, statusCode: statusCode, currentScore: currentScore)!
        let fakeExerciseSetCalculator = FakeExerciseSetCalculator()
        
        return DefaultOneFocusStrategy(exerciseSetCalculator: fakeExerciseSetCalculator, enrichedUserConcept: stubEnrichedUserConcept)
    }
    
    var unseenCode: Int {
        return EnrichedUserConcept.Status.unseen.rawValue
    }
    
    var introductionInProgressCode: Int {
        return EnrichedUserConcept.Status.introductionInProgress.rawValue
    }
    
    var introductionCompleteCode: Int {
        return EnrichedUserConcept.Status.introductionComplete.rawValue
    }

    
    
}
