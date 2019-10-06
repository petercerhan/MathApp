//
//  FeedPackageExternalDataServiceTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
import RxTest
@testable import MathApp

class FeedPackageExternalDataServiceTests: XCTestCase {
    
    //MARK: - getFeedPackage Tests
    
    func test_getFeedPackage_focusConcept1_concept1Unseen_shouldReturnConceptIntro1() {
        let stubDatabaseService = stubDatabaseServiceFor_focusConcept1(status: .unseen)
        let fakeRandomizationService = FakeRandomizationService()
        
        let calculator = FeedPackageCalculator(databaseService: stubDatabaseService, randomizationService: fakeRandomizationService)
        let package = calculator.getNextFeedPackage()
        
        XCTAssertEqual(package.feedPackageType, .conceptIntro)
        guard let conceptIntro = package.transitionItem as? ConceptIntro else {
            XCTFail("transition item is not concept intro")
            return
        }
        XCTAssertEqual(conceptIntro.concept.id, 1)
        XCTAssertEqual(package.exercises.count, 3)
    }
    
    func test_getFeedPackage_focusConcept1_concept1InProgress_scoreBelow5_shouldReturnExercisePackage() {
        let stubDatabaseService = stubDatabaseServiceFor_focusConcept1(status: .introductionInProgress)
        let fakeRandomizationService = FakeRandomizationService()
        
        let calculator = FeedPackageCalculator(databaseService: stubDatabaseService, randomizationService: fakeRandomizationService)
        let package = calculator.getNextFeedPackage()
        
        XCTAssertEqual(package.feedPackageType, .exercises)
        XCTAssertEqual(package.exercises.count, 3)
    }
    
    func test_getFeedPackage_focusConcept1_concept1InProgress_score5_shouldReturnLevelUpPackage() {
        let stubDatabaseService = stubDatabaseServiceFor_focusConcept1(status: .introductionInProgress, currentScore: 5)
        let fakeRandomizationService = FakeRandomizationService()
        
        let calculator = FeedPackageCalculator(databaseService: stubDatabaseService, randomizationService: fakeRandomizationService)
        let package = calculator.getNextFeedPackage()
        
        XCTAssertEqual(package.feedPackageType, .levelUp)
        XCTAssertEqual(package.exercises.count, 3)
        guard let levelUpItem = package.transitionItem as? LevelUpItem else {
            XCTFail("Transition item is not level up item")
            return
        }
        XCTAssertEqual(levelUpItem.previousLevel, 0)
        XCTAssertEqual(levelUpItem.newLevel, 1)
    }
    
    
    
    
    
    //MARK: - ConceptIntro Seen Tests
    
    func test_getFeedPackageIntroducedConcept_shouldUpdateConceptStatus() {
        let mockDatabaseService = stubDatabaseServiceFor_focusConcept1(status: .unseen)
        let fakeRandomizationService = FakeRandomizationService()
        
        let calculator = FeedPackageCalculator(databaseService: mockDatabaseService, randomizationService: fakeRandomizationService)
        let _ = calculator.getFeedPackage(introducedConceptID: 1)
        
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_callCount, 1)
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_status.first, EnrichedUserConcept.Status.introductionInProgress.rawValue)
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_id.first, 1)
    }
    
    func test_getFeedPackageIntroducedConcept_shouldUpdateFocusToIntroducedConcept() {
        let mockDatabaseService = stubDatabaseServiceFor_focusConcept1(status: .unseen)
        let fakeRandomizationService = FakeRandomizationService()
        
        let calculator = FeedPackageCalculator(databaseService: mockDatabaseService, randomizationService: fakeRandomizationService)
        let _ = calculator.getFeedPackage(introducedConceptID: 1)
        
        XCTAssertEqual(mockDatabaseService.setFocusConcepts_callCount, 1)
        XCTAssertEqual(mockDatabaseService.setFocusConcepts_concept1.first, 1)
        XCTAssertEqual(mockDatabaseService.setFocusConcepts_concept2.first, 0)
    }
    
    func test_getFeedPackageIntroducedConcept_shouldReturnExercisePackage() {
        let stubDatabaseService = stubDatabaseServiceFor_focusConcept1(status: .unseen)
        let fakeRandomizationService = FakeRandomizationService()
        
        let calculator = FeedPackageCalculator(databaseService: stubDatabaseService, randomizationService: fakeRandomizationService)
        let package = calculator.getFeedPackage(introducedConceptID: 1)
        
        XCTAssertEqual(package.feedPackageType, .exercises)
        XCTAssertEqual(package.exercises.count, 3)
    }
    
    
    
    
    //MARK: - LevelUp Tests
    
    func test_getFeedPackageLevelUp_shouldUpdateConceptLevel() {
        let mockDatabaseService = stubDatabaseServiceFor_focusConcept1(status: .introductionInProgress)
        let fakeRandomizationService = FakeRandomizationService()
        
        let calculator = FeedPackageCalculator(databaseService: mockDatabaseService, randomizationService: fakeRandomizationService)
        let _ = calculator.getFeedPackage(levelUpConceptID: 1)
        
        XCTAssertEqual(mockDatabaseService.incrementStrengthForUserConcept_callCount, 1)
        XCTAssertEqual(mockDatabaseService.incrementStrengthForUserConcept_conceptID.first, 1)
    }
    
    func test_getFeedPackageLevelUp_initialLevel0_shouldSetStatusToComplete() {
        let mockDatabaseService = stubDatabaseServiceFor_focusConcept1(status: .introductionInProgress)
        let fakeRandomizationService = FakeRandomizationService()
        
        let calculator = FeedPackageCalculator(databaseService: mockDatabaseService, randomizationService: fakeRandomizationService)
        let _ = calculator.getFeedPackage(levelUpConceptID: 1)
        
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_callCount, 1)
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_id.first, 1)
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_status.first, EnrichedUserConcept.Status.introductionComplete.rawValue)
    }
    
    //too complicated - introduce new concept conditions are, 1) no other concepts at level 1, 2) other concepts at level 0
    func test_getFeedPackageLevelUp_initialLevel0_introduceNewConceptConditions_shouldReturnConceptIntroPackage() {
        let mockDatabaseService = stubDatabaseServiceFor_focusConcept1(status: .introductionInProgress)
        let fakeRandomizationService = FakeRandomizationService()
        
        let calculator = FeedPackageCalculator(databaseService: mockDatabaseService, randomizationService: fakeRandomizationService)
        let package = calculator.getFeedPackage(levelUpConceptID: 1)
        
        XCTAssertEqual(package.feedPackageType, .conceptIntro)
        guard let conceptIntro = package.transitionItem as? ConceptIntro else {
            XCTFail("transition item is not concept intro")
            return
        }
        XCTAssertEqual(conceptIntro.concept.id, 2)
        XCTAssertEqual(package.exercises.count, 3)
    }
    
    
    //MARK: - DatabaseService Stubs
    
    private func stubDatabaseServiceFor_focusConcept1(status: EnrichedUserConcept.Status, currentScore: Int = 0) -> FakeDatabaseService {
        let stubDatabaseService = FakeDatabaseService()
        
        let stubUserConcepts = [UserConcept.constantRule, UserConcept.linearRule, UserConcept.powerRule, UserConcept.sumRule, UserConcept.differenceRule]
        let stubFocusConcepts = (1, 0)
        let stubEnrichedUserConcept = EnrichedUserConcept(userConcept: UserConcept.constantRule, statusCode: status.rawValue, currentScore: currentScore)
        
        stubDatabaseService.stubUserConcepts = stubUserConcepts
        stubDatabaseService.getFocusConcepts_stub = stubFocusConcepts
        stubDatabaseService.getEnrichedUserConcept_stub = stubEnrichedUserConcept
        stubDatabaseService.getExercises_stubData = [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
        
        return stubDatabaseService
    }
    
}
