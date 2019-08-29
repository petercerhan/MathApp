//
//  RxLatestValueTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 8/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import XCTest
import RxSwift
@testable import MathApp

class RxLatestValueTests: XCTestCase {
    
    func test_latestValue_valueIsSet_returnsValue() {
        let disposeBag = DisposeBag()
        let subject = BehaviorSubject<String>(value: "Hello")
        
        let value = latestValue(of: subject.asObservable(), disposeBag: disposeBag)
        
        delayedAssertion { XCTAssertEqual(value, "Hello") }
    }
    
    func test_latestValue_noValueSet_returnsNil() {
        let disposeBag = DisposeBag()
        let subject = PublishSubject<String>()
        
        var value: String? = "Hello"
        value = latestValue(of: subject.asObservable(), disposeBag: disposeBag)
        
        delayedAssertion { XCTAssertNil(value) }
    }
    
    func test_latestValue_error_returnsNil() {
        let disposeBag = DisposeBag()
        let observable = Observable<String>.error(NetworkRequestError.invalidData)
        
        var value: String? = "Hello"
        value = latestValue(of: observable, disposeBag: disposeBag)
        
        delayedAssertion { XCTAssertNil(value) }
    }
    
}
