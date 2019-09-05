//
//  ExerciseService.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol ExerciseService {
    func nextExercise() -> Exercise
}

class ExerciseServiceImpl: ExerciseService {
    
    private(set) var exerciseIndex = 0
    
    func nextExercise() -> Exercise {
        let exercise = Exercise.getByID(exerciseIndex + 1)
        exerciseIndex = (exerciseIndex + 1) % 2
        return exercise
    }
    
}
