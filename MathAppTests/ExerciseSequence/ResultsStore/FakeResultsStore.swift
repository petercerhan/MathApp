//
//  FakeResultsStore.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/1/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift
@testable import MathApp

class FakeResultsStore: ResultsStore {

    var correct = Observable<Int>.just(0)
    
    func dispatch(action: ResultsStoreAction) {
        
    }
}
