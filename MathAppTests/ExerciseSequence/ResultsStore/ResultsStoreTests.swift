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
    
    func test_correct_initialState_0() {
        let store = ResultsStoreImpl()
        
        let correct = latestValue(of: store.correct, disposeBag: disposeBag) ?? -1
        XCTAssertEqual(correct, 0)
    }
    
    func test_correctResult_incrementsCorrectCount() {
        let result = ExerciseResult(correct: true, conceptID: 1)
        let store = ResultsStoreImpl()
        
        store.dispatch(action: .processResult(result))
        
        let correct = latestValue(of: store.correct, disposeBag: disposeBag) ?? -1
        XCTAssertEqual(correct, 1)
    }
    
    
    
}
