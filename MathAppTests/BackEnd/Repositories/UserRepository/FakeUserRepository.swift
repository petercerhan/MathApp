//
//  FakeUserRepository.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/20/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeUserRepository: UserRepository {

    func get() -> User? {
        return nil
    }
    
    var setLearningStrategy_callCount = 0
    var setLearningStrategy_strategy = [LearningStrategy]()
    
    func setLearningStrategy(_ strategy: LearningStrategy) {
        setLearningStrategy_callCount += 1
        setLearningStrategy_strategy.append(strategy)
    }
    
}
