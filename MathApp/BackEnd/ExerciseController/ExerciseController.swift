//
//  ExerciseController.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol ExerciseController {
    func getExercises(conceptIDs: [Int]) -> [Exercise]
    func getExercise(id: Int) -> Exercise?
}

class ExerciseControllerImpl: ExerciseController {
    
    //MARK: - Dependencies
    
    private let userRepository: UserRepository
    private let exerciseStrategyFactory: ExerciseStrategyFactory
    private let exerciseRepository: ExerciseRepository
    
    //MARK: - Initialization
    
    init(userRepository: UserRepository,
         exerciseStrategyFactory: ExerciseStrategyFactory,
         exerciseRepository: ExerciseRepository)
    {
        self.userRepository = userRepository
        self.exerciseStrategyFactory = exerciseStrategyFactory
        self.exerciseRepository = exerciseRepository
    }
    
    //MARK: - ExerciseController Interface
    
    func getExercises(conceptIDs: [Int]) -> [Exercise] {
        let strategy = exerciseStrategyFactory.createStrategy(learningStrategy: .newMaterial)
        return strategy.getExercises(conceptIDs: conceptIDs)
    }
    
    func getExercise(id: Int) -> Exercise? {
        return exerciseRepository.get(id: id)
    }
    
}



