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

    var correct = Observable<Int>.just(0)
    
    var dispatch_callCount = 0
    var dispatch_action = [ResultsStoreAction]()
    
    func dispatch(action: ResultsStoreAction) {
        dispatch_callCount += 1
        dispatch_action.append(action)
    }
    
    func verifyIncrementCompleteDispatched(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(dispatch_callCount, 1, file: file, line: line)
        if dispatch_action.count > 0 {
            XCTAssert(dispatch_action[0].isincrementCorrectCase, file: file, line: line)
        } else {
            XCTFail("No action dispatched", file: file, line: line)
        }
    }
    
}
