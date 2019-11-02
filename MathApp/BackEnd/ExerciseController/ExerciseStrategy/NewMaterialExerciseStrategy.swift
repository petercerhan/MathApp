//
//  NewMaterialExerciseStrategy.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class NewMaterialExerciseStrategy: ExerciseStrategy {

    //MARK: - Dependencies
    
    let exerciseSetCalculator: ExerciseSetCalculator
    let newMaterialStateRepository: NewMaterialStateRepository
    
    //MARK: - Initialization
    
    init(exerciseSetCalculator: ExerciseSetCalculator,
         newMaterialStateRepository: NewMaterialStateRepository)
    {
        self.exerciseSetCalculator = exerciseSetCalculator
        self.newMaterialStateRepository = newMaterialStateRepository
    }
    
    //MARK: - NewMaterialExerciseStrategy Interface
    
    func getExercises() -> [Exercise] {
        let newMaterialState = newMaterialStateRepository.get()
        let concept1 = newMaterialState.focusConcept1ID
        let concept2 = newMaterialState.focusConcept2ID

        if concept2 == 0 {
            return exerciseSetCalculator.getExercisesForConcept(conceptID: concept1)
        } else {
            return exerciseSetCalculator.getExercisesTwoConcepts(concept1_id: concept1, concept2_id: concept2)
        }
    }
    
    func getExercises(conceptIDs: [Int]) -> [Exercise] {
        return exerciseSetCalculator.getExercises(conceptIDs: conceptIDs)
    }
    
}
