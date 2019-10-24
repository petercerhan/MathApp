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
    
    //MARK: - Dependencies
    
    private let exerciseSetCalculator: ExerciseSetCalculator
    private let newMaterialStateRepository: NewMaterialStateRepository
    
    //MARK: - Initiation
    
    init(exerciseSetCalculator: ExerciseSetCalculator, newMaterialStateRepository: NewMaterialStateRepository) {
        self.exerciseSetCalculator = exerciseSetCalculator
        self.newMaterialStateRepository = newMaterialStateRepository
    }
    
    //MARK: - ExerciseStrategyFactory Interface
    
    func createStrategy(learningStrategy: LearningStrategy) -> ExerciseStrategy {
        return NewMaterialExerciseStrategy(exerciseSetCalculator: exerciseSetCalculator, newMaterialStateRepository: newMaterialStateRepository)
    }
    
}


