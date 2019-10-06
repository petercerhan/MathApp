//
//  FakeExerciseSetCalculator.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/6/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeExerciseSetCalculator: ExerciseSetCalculator {
    
    func getExercisesForConcept(conceptID: Int, strength: Int) -> [Exercise] {
        return [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
    }
    
    func getExercisesTwoConcepts(concept1_id: Int, concept2_id: Int) -> [Exercise] {
        return [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
    }
    
}
