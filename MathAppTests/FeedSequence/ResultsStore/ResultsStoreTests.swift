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
        
        let correct = latestValue(of: store.points, disposeBag: disposeBag) ?? -1
        XCTAssertEqual(correct, 0)
    }
    
    func test_correctResult_shouldIncrementCorrectCount() {
        let store = composeSUT()
        
        let result = ExerciseResult(correct: true, conceptID: 1)
        store.dispatch(action: .processResult(result))
        
        let correct = latestValue(of: store.points, disposeBag: disposeBag) ?? -1
        XCTAssertEqual(correct, 1)
    }
    
    func test_incorrectResult_shouldNotIncrementCorrectCount() {
        let store = composeSUT()
        
        let result = ExerciseResult(correct: false, conceptID: 1)
        store.dispatch(action: .processResult(result))
        
        let correct = latestValue(of: store.points, disposeBag: disposeBag) ?? -1
        XCTAssertEqual(correct, 0)
    }
    
//    func test_scenario1_shouldShow1Of1() {
//        let store = composeSUT()
//        
//        store.dispatch(action: .processResult(ExerciseResult(correct: false, conceptID: 1)))
//        
//        
//    }
    
    //MARK: - Compose SUT
    
    func composeSUT(fakeDatabaseService: DatabaseService? = nil) -> ResultsStore {
        return ResultsStoreImpl()
    }
    
}
