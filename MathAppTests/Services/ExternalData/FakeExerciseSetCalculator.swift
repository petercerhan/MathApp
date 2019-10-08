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
    
    var getExercisesForConcept_callCount = 0
    var getExercisesForConcept_conceptID = [Int]()
    var getExercisesForConcept_strength = [Int]()
    func getExercisesForConcept(conceptID: Int, strength: Int) -> [Exercise] {
        getExercisesForConcept_callCount += 1
        getExercisesForConcept_conceptID.append(conceptID)
        getExercisesForConcept_strength.append(strength)
        
        return [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
    }
    
    var getExercisesTwoConcepts_callCount = 0
    var getExercisesTwoConcepts_concept1ID = [Int]()
    var getExercisesTwoConcepts_concept2ID = [Int]()
    func getExercisesTwoConcepts(concept1_id: Int, concept2_id: Int) -> [Exercise] {
        getExercisesTwoConcepts_callCount += 1
        getExercisesTwoConcepts_concept1ID.append(concept1_id)
        getExercisesTwoConcepts_concept2ID.append(concept2_id)
        
        return [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
    }
    
}
