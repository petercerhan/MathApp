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
    
    //MARK: - Tests for strategy invocation
    
    func test_getFeedPackage_twoFocusConcepts_shouldSupplyValuesToStrategyFactory() {
        let mockFeedPackageStrategyFactory = FakeFeedPackageStrategyFactory()
        let stubDatabaseService = FakeDatabaseService()
        stubDatabaseService.getFocusConcepts_stub = (2, 4)
        let calculator = FeedPackageCalculator(databaseService: stubDatabaseService, exerciseSetCalculator: FakeExerciseSetCalculator(), strategyFactory: mockFeedPackageStrategyFactory)
        
        _ = calculator.getNextFeedPackage()
        
        XCTAssertEqual(mockFeedPackageStrategyFactory.createOneFocusStrategy_callCount, 1)
        XCTAssertEqual(mockFeedPackageStrategyFactory.createOneFocusStrategy_concept1.first?.userConcept.concept.id, 2)
        guard let enrichedConcept2 = mockFeedPackageStrategyFactory.createOneFocusStrategy_concept2.first else {
            XCTFail("no second enriched concept received")
            return
        }
        XCTAssertEqual(enrichedConcept2?.userConcept.concept.id, 4)
    }
    
    func test_getFeedPackage_oneFocusConcept_shouldSupply1ValueToStrategyFactory() {
        let mockFeedPackageStrategyFactory = FakeFeedPackageStrategyFactory()
        let stubDatabaseService = FakeDatabaseService()
        stubDatabaseService.getFocusConcepts_stub = (2, 0)
        let calculator = FeedPackageCalculator(databaseService: stubDatabaseService, exerciseSetCalculator: FakeExerciseSetCalculator(), strategyFactory: mockFeedPackageStrategyFactory)
        
        _ = calculator.getNextFeedPackage()
        
        XCTAssertEqual(mockFeedPackageStrategyFactory.createOneFocusStrategy_callCount, 1)
        XCTAssertEqual(mockFeedPackageStrategyFactory.createOneFocusStrategy_concept1.first?.userConcept.concept.id, 2)
        guard let enrichedConcept2 = mockFeedPackageStrategyFactory.createOneFocusStrategy_concept2.first else {
            XCTFail("no second enriched concept received")
            return
        }
        XCTAssertNil(enrichedConcept2)
    }
    
    
    //MARK: - Prior Integration Tests
    
    //MARK: - getFeedPackage
    
    func test_getFeedPackage_focusConcept1_concept1Unseen_shouldReturnConceptIntro1() {
        let stubDatabaseService = getStubDatabaseService(status1: .unseen)
        let calculator = composeSUT(fakeDatabaseService: stubDatabaseService)

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
        let stubDatabaseService = getStubDatabaseService(status1: .introductionInProgress)
        let calculator = composeSUT(fakeDatabaseService: stubDatabaseService)

        let package = calculator.getNextFeedPackage()
        
        XCTAssertEqual(package.feedPackageType, .exercises)
        XCTAssertEqual(package.exercises.count, 3)
    }
    
    func test_getFeedPackage_focusConcept1_concept1InProgress_score5_shouldReturnLevelUpPackage() {
        let stubDatabaseService = getStubDatabaseService(status1: .introductionInProgress, currentScore: 5)
        let calculator = composeSUT(fakeDatabaseService: stubDatabaseService)

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
        let mockDatabaseService = getStubDatabaseService(status1: .unseen)
        let calculator = composeSUT(fakeDatabaseService: mockDatabaseService)

        let _ = calculator.getFeedPackage(introducedConceptID: 1)
        
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_callCount, 1)
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_status.first, EnrichedUserConcept.Status.introductionInProgress.rawValue)
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_id.first, 1)
    }
    
    func test_getFeedPackageIntroducedConcept_shouldUpdateFocusToIntroducedConcept() {
        let mockDatabaseService = getStubDatabaseService(status1: .unseen)
        let calculator = composeSUT(fakeDatabaseService: mockDatabaseService)
        
        let _ = calculator.getFeedPackage(introducedConceptID: 2)
        
        XCTAssertEqual(mockDatabaseService.setFocusConcepts_callCount, 1)
        XCTAssertEqual(mockDatabaseService.setFocusConcepts_concept1.first, 2)
        XCTAssertEqual(mockDatabaseService.setFocusConcepts_concept2.first, 0)
    }
    
    func test_getFeedPackageIntroducedConcept_shouldReturnExercisePackage() {
        let stubDatabaseService = getStubDatabaseService(status1: .unseen)
        let calculator = composeSUT(fakeDatabaseService: stubDatabaseService)

        let package = calculator.getFeedPackage(introducedConceptID: 1)
        
        XCTAssertEqual(package.feedPackageType, .exercises)
        XCTAssertEqual(package.exercises.count, 3)
    }
    
    //MARK: - LevelUp Tests
    
    func test_getFeedPackageLevelUp_shouldUpdateConceptLevel() {
        let mockDatabaseService = getStubDatabaseService(status1: .introductionInProgress)
        let calculator = composeSUT(fakeDatabaseService: mockDatabaseService)
        
        let _ = calculator.getFeedPackage(levelUpConceptID: 1)
        
        XCTAssertEqual(mockDatabaseService.incrementStrengthForUserConcept_callCount, 1)
        XCTAssertEqual(mockDatabaseService.incrementStrengthForUserConcept_conceptID.first, 1)
    }
    
    func test_getFeedPackageLevelUp_initialLevel0_shouldSetStatusToComplete() {
        let mockDatabaseService = getStubDatabaseService(status1: .introductionInProgress)
        let calculator = composeSUT(fakeDatabaseService: mockDatabaseService)
        
        let _ = calculator.getFeedPackage(levelUpConceptID: 1)
        
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_callCount, 1)
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_id.first, 1)
        XCTAssertEqual(mockDatabaseService.setUserConceptStatus_status.first, EnrichedUserConcept.Status.introductionComplete.rawValue)
    }
    
    //too complicated - introduce new concept conditions are, 1) no other concepts at level 1, 2) other concepts at level 0
    func test_getFeedPackageLevelUp_initialLevel0_introduceNewConceptConditions_shouldReturnConceptIntroPackage() {
        let mockDatabaseService = getStubDatabaseService(status1: .introductionInProgress)
        let calculator = composeSUT(fakeDatabaseService: mockDatabaseService)
        
        let package = calculator.getFeedPackage(levelUpConceptID: 1)
        
        XCTAssertEqual(package.feedPackageType, .conceptIntro)
        guard let conceptIntro = package.transitionItem as? ConceptIntro else {
            XCTFail("transition item is not concept intro")
            return
        }
        XCTAssertEqual(conceptIntro.concept.id, 2)
        XCTAssertEqual(package.exercises.count, 3)
    }
    
    //1) another concept at level 1
    func test_getFeedPackageLevelUp_initialLevel0_practiceTwoConceptsCondition_shouldReturnExercisesPackage() {
        let mockDatabaseService = getStubDatabaseService(focus1ID: 2, status1: .introductionInProgress, stubUserConcepts: userConcepts_1Level1)
        let calculator = composeSUT(fakeDatabaseService: mockDatabaseService)
        
        let package = calculator.getFeedPackage(levelUpConceptID: 2)
        
        XCTAssertEqual(package.feedPackageType, .exercises)
    }
    
    func test_getFeedPackageLevelUp_initialLevel0_practiceTwoConceptsCondition_shouldFetchTwoConceptExercises() {
        let mockExerciseSetCalculator = FakeExerciseSetCalculator()
        let stubDatabaseService = getStubDatabaseService(focus1ID: 2, status1: .introductionInProgress, stubUserConcepts: userConcepts_1Level1)
        let calculator = composeSUT(fakeDatabaseService: stubDatabaseService, fakeExerciseSetCalculator: mockExerciseSetCalculator)
        
        let _ = calculator.getFeedPackage(levelUpConceptID: 2)
        
        XCTAssertEqual(mockExerciseSetCalculator.getExercisesTwoConcepts_callCount, 1)
        XCTAssertEqual(mockExerciseSetCalculator.getExercisesTwoConcepts_concept1ID.first, 2)
        XCTAssertEqual(mockExerciseSetCalculator.getExercisesTwoConcepts_concept2ID.first, 1)
    }
    
    func test_getFeedPackageLevelUp_initialLevel0_practiceTwoConceptsCondition_shouldUpdateFocusToTwoConcepts() {
        let mockDatabaseService = getStubDatabaseService(focus1ID: 2, status1: .introductionInProgress, stubUserConcepts: userConcepts_1Level1)
        let calculator = composeSUT(fakeDatabaseService: mockDatabaseService)
        
        let _ = calculator.getFeedPackage(levelUpConceptID: 2)
        
        XCTAssertEqual(mockDatabaseService.setFocusConcepts_callCount, 1)
        XCTAssertEqual(mockDatabaseService.setFocusConcepts_concept1.first, 2)
        XCTAssertEqual(mockDatabaseService.setFocusConcepts_concept2.first, 1)
    }
    
    //all other concepts strength 2+
    func test_getFeedPackageLevelUp_initialLevel0_practiceSingleConceptCondition_shouldFetchSingleConceptExercises() {
        let mockExerciseSetCalculator = FakeExerciseSetCalculator()
        let mockDatabaseService = getStubDatabaseService(focus1ID: 2, status1: .introductionInProgress, stubUserConcepts: userConcepts_allLevel2)
        let calculator = composeSUT(fakeDatabaseService: mockDatabaseService, fakeExerciseSetCalculator: mockExerciseSetCalculator)
        
        let package = calculator.getFeedPackage(levelUpConceptID: 2)
        
        XCTAssertEqual(package.feedPackageType, .exercises)
        XCTAssertEqual(mockExerciseSetCalculator.getExercisesForConcept_callCount, 1)
        XCTAssertEqual(mockExerciseSetCalculator.getExercisesForConcept_conceptID.first, 2)
    }
    
    //MARK: - SUT Composition
    
    private func composeSUT(fakeDatabaseService: FakeDatabaseService? = nil, fakeExerciseSetCalculator: FakeExerciseSetCalculator? = nil) -> FeedPackageCalculator
    {
        let databaseService = fakeDatabaseService ?? FakeDatabaseService()
        let exerciseSetCalculator = fakeExerciseSetCalculator ?? FakeExerciseSetCalculator()
        
        let strategyFactory = DefaultFeedPackageStrategyFactory()
        
        return FeedPackageCalculator(databaseService: databaseService,
                                     exerciseSetCalculator: exerciseSetCalculator,
                                     strategyFactory: strategyFactory)
    }
    
    //MARK: - DatabaseService Stubs
    
    private func getStubDatabaseService(focus1ID: Int = 1,
                                        focus2ID: Int = 0,
                                        status1: EnrichedUserConcept.Status = .unseen,
                                        currentScore: Int = 0,
                                        stubUserConcepts: [UserConcept]? = nil) -> FakeDatabaseService
    {
        let stubDatabaseService = FakeDatabaseService()
        
        let userConcepts = stubUserConcepts ?? userConcepts_allUnseen
        let stubFocusConcepts = (focus1ID, focus2ID)
        let stubEnrichedUserConcept = EnrichedUserConcept(userConcept: UserConcept.constantRule, statusCode: status1.rawValue, currentScore: currentScore)
        
        stubDatabaseService.stubUserConcepts = userConcepts
        stubDatabaseService.getFocusConcepts_stub = stubFocusConcepts
        stubDatabaseService.getEnrichedUserConcept_stub = stubEnrichedUserConcept
        stubDatabaseService.getExercises_stubData = [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
        
        return stubDatabaseService
    }
    
    private var userConcepts_allUnseen: [UserConcept] {
        return [UserConcept.constantRule, UserConcept.linearRule, UserConcept.powerRule, UserConcept.sumRule, UserConcept.differenceRule]
    }
    
    private var userConcepts_1Level1: [UserConcept] {
        let constantRule = UserConcept(id: 1, concept: Concept.constantRule, strength: 1)
        return [constantRule, UserConcept.linearRule, UserConcept.powerRule, UserConcept.sumRule, UserConcept.differenceRule]
    }
    
    private var userConcepts_allLevel2: [UserConcept] {
        let rule1 = UserConcept(id: 1, concept: Concept.constantRule, strength: 2)
        let rule2 = UserConcept(id: 2, concept: Concept.linearRule, strength: 2)
        let rule3 = UserConcept(id: 3, concept: Concept.powerRule, strength: 2)
        let rule4 = UserConcept(id: 4, concept: Concept.sumRule, strength: 2)
        let rule5 = UserConcept(id: 5, concept: Concept.differenceRule, strength: 2)
        
        return [rule1, rule2, rule3, rule4, rule5]
    }
    
}
