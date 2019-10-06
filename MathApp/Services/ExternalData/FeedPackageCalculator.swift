//
//  FeedPackageCalculator.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class FeedPackageCalculator {

    //MARK: - Dependencies
    
    private let databaseService: DatabaseService
    private let randomizationService: RandomizationService
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService, randomizationService: RandomizationService) {
        self.databaseService = databaseService
        self.randomizationService = randomizationService
    }
    
    //MARK: - FeedPackageCalculator Interface
        
    func getNextFeedPackage() -> FeedPackage {
        let focusConcepts = databaseService.getFocusConcepts()
        let concept1_id = focusConcepts.0
//        let concept2_id = focusConcepts.1
        
        guard let enrichedUserConcept_1 = databaseService.getEnrichedUserConcept(conceptID: concept1_id) else {
            return getExercises_prior()
        }
        let concept1 = enrichedUserConcept_1.userConcept.concept
        let strength1 = enrichedUserConcept_1.userConcept.strength
        
        print("concept 1 score: \(enrichedUserConcept_1.currentScore)")

        if enrichedUserConcept_1.status == .unseen {
            print("concept intro for concept \(concept1_id)")

            let conceptIntro = ConceptIntro(concept: concept1)
            
            //should actually be exercises for previous concept, (if none, no exercises (will this work?))
            
            let exercises = getExercisesForConcept(conceptID: enrichedUserConcept_1.userConcept.concept.id, strength: strength1)
            let feedPackage = FeedPackage(feedPackageType: .conceptIntro, exercises: exercises, transitionItem: conceptIntro)
            return feedPackage
        }
        
        if enrichedUserConcept_1.status == .introductionInProgress, enrichedUserConcept_1.currentScore < 5 {
            print("in progress exercises for concept \(concept1_id)")
            
            let exercises = getExercisesForConcept(conceptID: concept1_id, strength: strength1)
            let feedPackage = FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
            return feedPackage
        }
        
        if enrichedUserConcept_1.status == .introductionInProgress, enrichedUserConcept_1.currentScore >= 5 {
            print("level up for concept \(enrichedUserConcept_1.userConcept.concept.id)")
            
            let exercises = getExercisesForConcept(conceptID: enrichedUserConcept_1.userConcept.concept.id, strength: enrichedUserConcept_1.userConcept.strength)
            let levelUpItem = LevelUpItem(concept: concept1, previousLevel: strength1, newLevel: strength1 + 1)
            let feedPackage = FeedPackage(feedPackageType: .levelUp, exercises: exercises, transitionItem: levelUpItem)
            return feedPackage
        }
        
        
        return getExercises_prior()
    }
    
    private func getExercisesForConcept(conceptID: Int, strength: Int) -> [Exercise] {
        
        print("get exercises for concept: \(conceptID), strength: \(strength)")
        
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
    
    func getFeedPackage(introducedConceptID: Int) -> FeedPackage {
        print("exercises package for introduced concept \(introducedConceptID)")
        
        databaseService.setUserConceptStatus(EnrichedUserConcept.Status.introductionInProgress.rawValue, forConceptID: introducedConceptID)
        databaseService.setFocusConcepts(concept1: introducedConceptID, concept2: 0)
        let exercises = getExercisesForConcept(conceptID: introducedConceptID, strength: 0)
        return FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
    }
    
    func getFeedPackage(levelUpConceptID: Int) -> FeedPackage {
        
        guard let enrichedUserConcept = databaseService.getEnrichedUserConcept(conceptID: levelUpConceptID) else {
            return getExercises_prior()
        }
        let priorStrength = enrichedUserConcept.userConcept.strength
        let newStrength = min(priorStrength + 1, 3)
        let userConcepts = databaseService.getUserConcepts()
                .filter { $0.concept.id != levelUpConceptID }
                .sorted { $0.concept.id < $1.concept.id }
        
        print("exercises package for level up concept \(levelUpConceptID), strength \(newStrength)")

        databaseService.incrementStrengthForUserConcept(conceptID: levelUpConceptID)
        
        if priorStrength == 0 {
            databaseService.setUserConceptStatus(EnrichedUserConcept.Status.introductionComplete.rawValue, forConceptID: levelUpConceptID)
        }
        
        //Three cases:
        
        if let secondStrength1Concept = userConcepts.first(where: { $0.strength == 1 } ) {
            //second, if there is another with strength 1, double concept exercise package
        }
        else if let introduceSecondConcept = userConcepts.first(where: { $0.strength == 0 } ) {
            print("package to introduce concept \(introduceSecondConcept.concept.id)")
            
            return conceptIntroPackage(forConcept: introduceSecondConcept.concept)
        }
        else if allConceptsHaveStrengthTwoPlus(conceptArray: userConcepts) {
            //first, if all other concepts in concept-family have strength 2+, single concept exercise package
        }
        
        
        let exercises = getExercisesForConcept(conceptID: levelUpConceptID, strength: newStrength)
        return FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
    }
    
    private func conceptIntroPackage(forConcept concept: Concept) -> FeedPackage {
        let conceptIntro = ConceptIntro(concept: concept)
        let exercises = getExercisesForConcept(conceptID: concept.id, strength: 0)
        let conceptIntroPackage = FeedPackage(feedPackageType: .conceptIntro, exercises: exercises, transitionItem: conceptIntro)
        return conceptIntroPackage
    }
    
    private func allConceptsHaveStrengthTwoPlus(conceptArray: [UserConcept]) -> Bool {
        let strengthLessThanTwoCount = conceptArray.reduce(0) { $0 + ($1.strength < 2 ? 1 : 0) }
        return (strengthLessThanTwoCount > 0)
    }
    
    
    
    //get exercises for two focus concepts
    private func getExercises_prior() -> FeedPackage {
        let concept1 = Concept.constantRule
        let concept2 = Concept.linearRule
        
        let exercises_concept1 = databaseService.getExercises(forConceptID: concept1.id)
        let exercises_concept2 = databaseService.getExercises(forConceptID: concept2.id)
        
        //randomly select which concept to choose from
        let conceptSelections = randomizationService.setFromRange(min: 0, max: 1, selectionCount: 3)
        let concept1Count = conceptSelections.reduce(0) { $0 + ($1 == 0 ? 1 : 0) }
        let concept2Count = conceptSelections.reduce(0) { $0 + ($1 == 1 ? 1 : 0)}
        
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
    
        let feedPackage = FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
        
        return feedPackage
    }
    
    func getExercise(id: Int) -> Exercise {
        let exercise = databaseService.getExercise(id: id)
        return exercise ?? Exercise.exercise1
    }
}
