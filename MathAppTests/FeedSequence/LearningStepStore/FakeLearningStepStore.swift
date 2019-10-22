//
//  FakeLearningStepStore.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/21/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift
@testable import MathApp

class FakeLearningStepStore: LearningStepStore {

    var learningStep = Observable<LoadState<LearningStep>>.just(.noData)
    
    var next_callCount = 0
    
    func dispatch(action: LearningStepStoreAction) {
        switch action {
        case .next:
            next_callCount += 1
        }
    }
    
}

