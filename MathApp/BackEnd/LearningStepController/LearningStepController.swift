//
//  LearningStepController.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol LearningStepController {
    func nextLearningStep() -> LearningStep
}

class LearningStepControllerImpl: LearningStepController {
    
    //MARK: - Dependencies
    
    private let learningStepStrategyFactory: LearningStepStrategyFactory
    
    //MARK: - Initialization
    
    init(learningStepStrategyFactory: LearningStepStrategyFactory) {
        self.learningStepStrategyFactory = learningStepStrategyFactory
    }
    
    //MARK: - LearningStepController Interface
    
    func nextLearningStep() -> LearningStep {
        let strategy = learningStepStrategyFactory.getStrategy(learningStrategy: .newMaterial)
        return strategy.nextLearningStep()
    }
    
}
