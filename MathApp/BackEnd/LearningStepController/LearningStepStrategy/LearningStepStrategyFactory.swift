//
//  LearningStepStrategyFactory.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol LearningStepStrategyFactory {
    func getStrategy(learningStrategy: LearningStrategy) -> LearningStepStrategy
}

class LearningStepStrategyFactoryImpl: LearningStepStrategyFactory {
    
    func getStrategy(learningStrategy: LearningStrategy) -> LearningStepStrategy {
        return NewMaterialLearningStepStrategy()
    }
    
}
