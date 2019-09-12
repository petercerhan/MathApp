//
//  ResultsStoreTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import MathApp

class ResultsStoreTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    func test_correct_initialState_shouldBe0() {
        let store = composeSUT()
        
        let correct = latestValue(of: store.correct, disposeBag: disposeBag) ?? -1
        XCTAssertEqual(correct, 0)
    }
    
    func test_correctResult_shouldIncrementsCorrectCount() {
        let store = composeSUT()
        
        let result = ExerciseResult(correct: true, conceptID: 1)
        store.dispatch(action: .processResult(result))
        
        let correct = latestValue(of: store.correct, disposeBag: disposeBag) ?? -1
        XCTAssertEqual(correct, 1)
    }
    
    func test_incorrectResult_shouldNotIncrementCorrectCount() {
        let store = composeSUT()
        
        let result = ExerciseResult(correct: false, conceptID: 1)
        store.dispatch(action: .processResult(result))
        
        let correct = latestValue(of: store.correct, disposeBag: disposeBag) ?? -1
        XCTAssertEqual(correct, 0)
    }
    
    func test_concept1_5of5Correct_shouldIncrementStrength() {
        let mockDatabaseService = FakeDatabaseService()
        let store = composeSUT(fakeDatabaseService: mockDatabaseService)

        let result = ExerciseResult(correct: true, conceptID: 1)
        store.dispatch(action: .processResult(result))
        store.dispatch(action: .processResult(result))
        store.dispatch(action: .processResult(result))
        store.dispatch(action: .processResult(result))
        store.dispatch(action: .processResult(result))

        XCTAssertEqual(mockDatabaseService.incrementStrengthForUserConcept_callCount, 1)
    }
    
    func test_concept1_4of5Correct_shouldIncrementStrength() {
        let mockDatabaseService = FakeDatabaseService()
        let store = composeSUT(fakeDatabaseService: mockDatabaseService)
        
        let result = ExerciseResult(correct: true, conceptID: 1)
        store.dispatch(action: .processResult(result))
        store.dispatch(action: .processResult(result))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(result))
        store.dispatch(action: .processResult(result))
        
        XCTAssertEqual(mockDatabaseService.incrementStrengthForUserConcept_callCount, 1)
    }
    
    func test_concept1_3of5Correct_shouldNotChangeStrength() {
        let mockDatabaseService = FakeDatabaseService()
        let store = composeSUT(fakeDatabaseService: mockDatabaseService)
        
        let result = ExerciseResult(correct: true, conceptID: 1)
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(result))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(result))
        store.dispatch(action: .processResult(result))
        
        XCTAssertEqual(mockDatabaseService.incrementStrengthForUserConcept_callCount, 0)
    }
    
    func test_concept1_2of5Correct_shouldDecementStrength() {
        let mockDatabaseService = FakeDatabaseService()
        let store = composeSUT(fakeDatabaseService: mockDatabaseService)
        
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: true, conceptID: 1)))
        
        XCTAssertEqual(mockDatabaseService.decrementStrengthForUserConcept_callCount, 1)
    }
    
    func test_concept1_0of5Correct_shouldDecementStrength() {
        let mockDatabaseService = FakeDatabaseService()
        let store = composeSUT(fakeDatabaseService: mockDatabaseService)
        
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
        
        XCTAssertEqual(mockDatabaseService.decrementStrengthForUserConcept_callCount, 1)
    }
    
    
    
    //MARK: - Compose SUT
    
    func composeSUT(fakeDatabaseService: DatabaseService? = nil) -> ResultsStore {
        let databaseService = fakeDatabaseService ?? FakeDatabaseService()
        return ResultsStoreImpl(databaseService: databaseService)
    }
    
}
