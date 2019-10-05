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
    
    func test_getFeedPackage_focusConcept1_concept1Unseen_shouldIntroduceConcept1() {
        let stubDatabaseService = stubDatabaseServiceFor_focusConcept1_concept1Unseen()
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
    
    
    
    private func stubDatabaseServiceFor_focusConcept1_concept1Unseen() -> DatabaseService {
        let stubDatabaseService = FakeDatabaseService()
        
        let stubUserConcepts = [UserConcept.constantRule, UserConcept.linearRule, UserConcept.powerRule, UserConcept.sumRule, UserConcept.differenceRule]
        let stubFocusConcepts = (1, 0)
        let stubEnrichedUserConcept = EnrichedUserConcept(userConcept: UserConcept.constantRule, statusCode: 1, currentScore: 0)
        
        stubDatabaseService.stubUserConcepts = stubUserConcepts
        stubDatabaseService.getFocusConcepts_stub = stubFocusConcepts
        stubDatabaseService.getEnrichedUserConcept_stub = stubEnrichedUserConcept
        stubDatabaseService.getExercises_stubData = [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
        
        return stubDatabaseService
    }
    
    
    
    
}
