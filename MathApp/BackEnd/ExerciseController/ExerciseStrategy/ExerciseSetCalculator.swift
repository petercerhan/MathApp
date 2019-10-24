//
//  ExerciseSetCalculator.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/6/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol ExerciseSetCalculator {
    func getExercisesForConcept(conceptID: Int, strength: Int) -> [Exercise]
    func getExercisesTwoConcepts(concept1_id: Int, concept2_id: Int) -> [Exercise]
}

class ExerciseSetCalculatorImpl: ExerciseSetCalculator {
    
    //MARK: - Dependencies
    
    private let databaseService: DatabaseService
    private let randomizationService: RandomizationService
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService, randomizationService: RandomizationService) {
        self.databaseService = databaseService
        self.randomizationService = randomizationService
    }
    
    //MARK: - ExerciseSetCalculator Interface
    
    func getExercisesForConcept(conceptID: Int, strength: Int) -> [Exercise] {
        let unfilteredExercises = databaseService.getExercises(forConceptID: conceptID)
        let weightTable = weightTableForStrength(strength)
        let difficulties = randomizationService.setFromRange(min: 1, max: 3, selectionCount: 3, weightTable: weightTable)
        
        var exercises = [Exercise]()
        
        for i in 0...2 {
            var newExercise: Exercise? = nil

            while newExercise == nil {
                let difficulty = difficulties[i]
                let exercisePool = unfilteredExercises.filter { $0.difficulty == difficulty }
                let exerciseIndex = randomizationService.intFromRange(min: 0, max: exercisePool.count - 1)
                let exercise = exercisePool[exerciseIndex]

                if let _ = exercises.first(where: { $0.id == exercise.id }) {
                    continue
                } else {
                    newExercise = exercise
                }
            }
            
            exercises.append(newExercise!)
        }
        
        return exercises
    }
    
    func getExercisesTwoConcepts(concept1_id: Int, concept2_id: Int) -> [Exercise] {
            let exercises_concept1 = databaseService.getExercises(forConceptID: concept1_id)
            let exercises_concept2 = databaseService.getExercises(forConceptID: concept2_id)
            
            //randomly select which concept to choose from
            let conceptSelections = randomizationService.setFromRange(min: 0, max: 1, selectionCount: 3)
            print("concept spread: \(conceptSelections)")
            
            let concept1Count = conceptSelections.reduce(0) { $0 + ($1 == 0 ? 1 : 0) }
            let concept2Count = conceptSelections.reduce(0) { $0 + ($1 == 1 ? 1 : 0) }
            
            //use weighted selection to choose difficulties
            let concept1Difficulties = randomizationService.setFromRange(min: 1, max: 3, selectionCount: concept1Count, weightTable: [0.2, 0.6, 0.2])
            let concept2Difficulties = randomizationService.setFromRange(min: 1, max: 3, selectionCount: concept2Count, weightTable: [0.2, 0.6, 0.2])
            
            //randomly choose from arrays filtered by criteria
            var concept1DifficultyIndex = 0
            var concept2DifficultyIndex = 0
            
            var exercises = [Exercise]()
            
            for i in 0...conceptSelections.count - 1 {
                if conceptSelections[i] == 0 {
                    //add concept 1 items
                    var newExercise: Exercise? = nil
                    
                    while newExercise == nil {
                        let difficulty = concept1Difficulties[concept1DifficultyIndex]
                        let exercisePool = exercises_concept1.filter { $0.difficulty == difficulty }
                        let exerciseIndex = randomizationService.intFromRange(min: 0, max: exercisePool.count - 1)
                        let exercise = exercisePool[exerciseIndex]
                        if let _ = exercises.first(where: { $0.id == exercise.id }) {
                            continue
                        } else {
                            newExercise = exercise
                        }
                    }
                    
                    exercises.append(newExercise!)
                    concept1DifficultyIndex += 1
                    
                } else {
                    //add concept 2 items
                    var newExercise: Exercise? = nil
                    
                    while newExercise == nil {
                        let difficulty = concept2Difficulties[concept2DifficultyIndex]
                        let exercisePool = exercises_concept2.filter { $0.difficulty == difficulty }
                        let exerciseIndex = randomizationService.intFromRange(min: 0, max: exercisePool.count - 1)
                        let exercise = exercisePool[exerciseIndex]
                        if let _ = exercises.first(where: { $0.id == exercise.id }) {
                            continue
                        } else {
                            newExercise = exercise
                        }
                    }
                    
                    exercises.append(newExercise!)
                    concept2DifficultyIndex += 1
                }
            }
        
            return exercises
    }
    
    private func weightTableForStrength(_ strength: Int) -> [Double] {
        switch strength {
        case 0:
            return [1.0, 0.0, 0.0]
        case 1:
            return [0.5, 0.5, 0.0]
        case 2:
            return [0.2, 0.6, 0.2]
        case 3:
            return [0.0, 0.4, 0.6]
        default:
            return [1.0, 0.0, 0.0]
        }
    }
    
}