//
//  FakeResultsStore.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import MathApp

class FakeResultsStore: ResultsStore {
    
    var progressState = Observable<ProgressState>.just(ProgressState(required: 5, correct: 0))

    var points = Observable<Int>.just(0)
    
    var dispatch_callCount = 0
    var dispatch_action = [ResultsStoreAction]()
    
    func dispatch(action: ResultsStoreAction) {
        dispatch_callCount += 1
        dispatch_action.append(action)
    }
    
    func verifyProcessResultDispatched(correct: Bool, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(dispatch_callCount, 1, file: file, line: line)
        if dispatch_action.count > 0 {
            if case let .processResult(result) = dispatch_action[0] {
                XCTAssertEqual(result.correct, correct, "Result correct is \(result.correct), expected \(correct)", file: file, line: line)
            } else {
                XCTFail("Dispatched action does not match \(dispatch_action[0])", file: file, line: line)
            }
        } else {
            XCTFail("No action dispatched", file: file, line: line)
        }
        
    }
    
}
