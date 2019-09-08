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
    func delayedAssertion(_ assertion: @escaping () -> () ) {
        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            assertion()
            expectation.fulfill()
        }
        wait(for:[expectation], timeout: 0.05)
    }
    
    
}

