//
//  FakeLearningStepStrategyFactory.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeLearningStepStrategyFactory: LearningStepStrategyFactory {
    
    var getStrategy_callCount = 0
    var getStrategy_learningStrategy = [LearningStrategy]()
    
    func getStrategy(learningStrategy: LearningStrategy) -> LearningStepStrategy {
        getStrategy_callCount += 1
        getStrategy_learningStrategy.append(learningStrategy)
        
        return NewMaterialLearningStepStrategy(userConceptRepository: FakeUserConceptRepository(), newMaterialStateRepository: FakeNewMaterialStateRepository())
    }
    
}
