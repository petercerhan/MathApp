//
//  TestUtilities.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 8/29/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import XCTest
@testable import MathApp
import RxSwift
import RxTest

func getNewObserver<T>() -> TestableObserver<T> {
    let scheduler = TestScheduler(initialClock: 0)
    return scheduler.createObserver(T.self)
}

extension XCTestCase {
    
    func delayedAssertion(delay: Double, _ assertion: @escaping () -> () ) {
        let expectation = XCTestExpectation()
        let expectationTimeout = max(delay + 0.1, 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            assertion()
            expectation.fulfill()
        }
        wait(for:[expectation], timeout: expectationTimeout)
    }
    
    func delayedAssertion(_ assertion: @escaping () -> () ) {
        delayedAssertion(delay: 0.005, assertion)
    }
    
}

