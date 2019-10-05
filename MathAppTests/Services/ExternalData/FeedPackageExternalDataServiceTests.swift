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
    
    func test_getFeedPackage_focusConcept1_concept1Unseen_shouldReturnConceptIntro1() {
        let stubDatabaseService = stubDatabaseServiceFor_focuseConcept1(status: .unseen)
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
    
    func test_getFeedPackage_focusConcept1_concept1InProgress_shouldReturnExercisePackage() {
        let stubDatabaseService = stubDatabaseServiceFor_focuseConcept1(status: .introductionInProgress)
        let fakeRandomizationService = FakeRandomizationService()
        
        let calculator = FeedPackageCalculator(databaseService: stubDatabaseService, randomizationService: fakeRandomizationService)
        let package = calculator.getNextFeedPackage()
        
        XCTAssertEqual(package.feedPackageType, .exercises)
        XCTAssertEqual(package.exercises.count, 3)
    }
    
    
    func test_getFeedPackageIntroducedConceptID_shouldUpdateConceptStatus() {
        let mockDatabaseService = stubDatabaseServiceFor_focuseConcept1(status: .unseen)
        let fakeRandomizationService = FakeRandomizationService()
        
        let calculator = FeedPackageCalculator(databaseService: mockDatabaseService, randomizationService: fakeRandomizationService)
        let _ = calculator.getFeedPackage(introducedConceptID: 1)
        
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_callCount, 1)
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_status.first, 2)
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_id.first, 1)
    }
    
    func test_getFeedPackageIntroducedConceptID_shouldReturnExercisePackage() {
        let stubDatabaseService = stubDatabaseServiceFor_focuseConcept1(status: .unseen)
        let fakeRandomizationService = FakeRandomizationService()
        
        let calculator = FeedPackageCalculator(databaseService: stubDatabaseService, randomizationService: fakeRandomizationService)
        let package = calculator.getFeedPackage(introducedConceptID: 1)
        
        XCTAssertEqual(package.feedPackageType, .exercises)
        XCTAssertEqual(package.exercises.count, 3)
    }
    
    
    
    
    
    //MARK: - DatabaseService Stubs
    
    private func stubDatabaseServiceFor_focuseConcept1(status: EnrichedUserConcept.Status) -> FakeDatabaseService {
        let stubDatabaseService = FakeDatabaseService()
        
        let stubUserConcepts = [UserConcept.constantRule, UserConcept.linearRule, UserConcept.powerRule, UserConcept.sumRule, UserConcept.differenceRule]
        let stubFocusConcepts = (1, 0)
        let stubEnrichedUserConcept = EnrichedUserConcept(userConcept: UserConcept.constantRule, statusCode: status.rawValue, currentScore: 0)
        
        stubDatabaseService.stubUserConcepts = stubUserConcepts
        stubDatabaseService.getFocusConcepts_stub = stubFocusConcepts
        stubDatabaseService.getEnrichedUserConcept_stub = stubEnrichedUserConcept
        stubDatabaseService.getExercises_stubData = [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
        
        return stubDatabaseService
    }
    
}
