//
//  ExerciseStrategyFactory.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol ExerciseStrategyFactory {
    func createStrategy(learningStrategy: LearningStrategy) -> ExerciseStrategy
}

class ExerciseStrategyFactoryImpl: ExerciseStrategyFactory {
    
    //MARK: - ExerciseStrategyFactory Interface
    
    func createStrategy(learningStrategy: LearningStrategy) -> ExerciseStrategy {
        return NewMaterialExerciseStrategy()
    }
    
}


