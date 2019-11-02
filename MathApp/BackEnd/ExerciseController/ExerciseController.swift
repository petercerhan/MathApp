//
//  ExerciseController.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol ExerciseController {
    func getExercises() -> [Exercise]
    func getExercises(conceptIDs: [Int]) -> [Exercise]
}

class ExerciseControllerImpl: ExerciseController {
    
    //MARK: - Dependencies
    
    private let userRepository: UserRepository
    private let exerciseStrategyFactory: ExerciseStrategyFactory
    
    //MARK: - Initialization
    
    init(userRepository: UserRepository,
         exerciseStrategyFactory: ExerciseStrategyFactory)
    {
        self.userRepository = userRepository
        self.exerciseStrategyFactory = exerciseStrategyFactory
    }
    
    //MARK: - ExerciseController Interface
    
    func getExercises() -> [Exercise] {
        let strategy = exerciseStrategyFactory.createStrategy(learningStrategy: .newMaterial)
        return strategy.getExercises()
    }
    
    func getExercises(conceptIDs: [Int]) -> [Exercise] {
        return getExercises()
    }
    
}



