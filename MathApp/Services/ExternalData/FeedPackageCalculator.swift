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
//    private let randomizationService: RandomizationService
    private let exerciseSetCalculator: ExerciseSetCalculator
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService,
         exerciseSetCalculator: ExerciseSetCalculator)
    {
        self.databaseService = databaseService
        self.exerciseSetCalculator = exerciseSetCalculator
    }
    
    //MARK: - FeedPackageCalculator Interface
        
    func getNextFeedPackage() -> FeedPackage {
        
        print("\ngetNextFeedPackage():")
        
        let focusConcepts = databaseService.getFocusConcepts()
        let concept1_id = focusConcepts.0
//        let concept2_id = focusConcepts.1
        
        guard let enrichedUserConcept_1 = databaseService.getEnrichedUserConcept(conceptID: concept1_id) else {
            return getExercises_prior()
        }
        let concept1 = enrichedUserConcept_1.userConcept.concept
        let strength1 = enrichedUserConcept_1.userConcept.strength

        if enrichedUserConcept_1.status == .unseen {
            print("concept intro for concept \(concept1_id)")

            let conceptIntro = ConceptIntro(concept: concept1)
            
            //should actually be exercises for previous concept, (if none, no exercises (will this work?))
            
            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID:  enrichedUserConcept_1.userConcept.concept.id, strength: strength1)
            let feedPackage = FeedPackage(feedPackageType: .conceptIntro, exercises: exercises, transitionItem: conceptIntro)
            return feedPackage
        }
        
        if enrichedUserConcept_1.status == .introductionInProgress, enrichedUserConcept_1.currentScore < 5 {
            print("in progress exercises for concept \(concept1_id)")
            
            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: concept1_id, strength: strength1)
            let feedPackage = FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
            return feedPackage
        }
        
        if enrichedUserConcept_1.status == .introductionInProgress, enrichedUserConcept_1.currentScore >= 5 {
            print("level up for concept \(enrichedUserConcept_1.userConcept.concept.id)")
            
            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: enrichedUserConcept_1.userConcept.concept.id, strength: enrichedUserConcept_1.userConcept.strength)
            let levelUpItem = LevelUpItem(concept: concept1, previousLevel: strength1, newLevel: strength1 + 1)
            let feedPackage = FeedPackage(feedPackageType: .levelUp, exercises: exercises, transitionItem: levelUpItem)
            return feedPackage
        }
        
        print("Fall-through exercise package")
        
        return getExercises_prior()
    }
    
    func getFeedPackage(introducedConceptID: Int) -> FeedPackage {
        
        print("\ngetNextFeedPackage() introduced concept \(introducedConceptID):")
        
        print("exercises package for introduced concept \(introducedConceptID)")
        
        databaseService.setUserConceptStatus(EnrichedUserConcept.Status.introductionInProgress.rawValue, forConceptID: introducedConceptID)
        databaseService.setFocusConcepts(concept1: introducedConceptID, concept2: 0)
        
        let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: introducedConceptID, strength: 0)
        return FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
    }
    
    func getFeedPackage(levelUpConceptID: Int) -> FeedPackage {
        
        print("\ngetNextFeedPackage() level up concept \(levelUpConceptID):")
        
        guard let enrichedUserConcept = databaseService.getEnrichedUserConcept(conceptID: levelUpConceptID) else {
            return getExercises_prior()
        }
        let priorStrength = enrichedUserConcept.userConcept.strength
        let newStrength = min(priorStrength + 1, 3)
        let userConcepts = databaseService.getUserConcepts()
                .filter { $0.concept.id != levelUpConceptID }
                .sorted { $0.concept.id < $1.concept.id }

        databaseService.incrementStrengthForUserConcept(conceptID: levelUpConceptID)
        
        if priorStrength == 0 {
            databaseService.setUserConceptStatus(EnrichedUserConcept.Status.introductionComplete.rawValue, forConceptID: levelUpConceptID)
        }
        
        //Three cases:
        
        //These are strength 0 cases for now:
        
        if let secondStrength1Concept = userConcepts.first(where: { $0.strength == 1 } ) {
            //first, if there is another with strength 1, double concept exercise package
            
            print("exercises for two concepts \(levelUpConceptID) \(secondStrength1Concept.id)")
            
            databaseService.setFocusConcepts(concept1: levelUpConceptID, concept2: secondStrength1Concept.id)

            let exercises = exerciseSetCalculator.getExercisesTwoConcepts(concept1_id: levelUpConceptID, concept2_id: secondStrength1Concept.id)
            return FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
        }
        else if let introduceSecondConcept = userConcepts.first(where: { $0.strength == 0 } ) {
            print("concept intro package for: \(introduceSecondConcept.concept.id)")
            
            return conceptIntroPackage(forConcept: introduceSecondConcept.concept)
        }
        else {
            print("exercise for single concept: \(levelUpConceptID)")

            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: levelUpConceptID, strength: newStrength)
            return FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
        }
    }
    
    private func conceptIntroPackage(forConcept concept: Concept) -> FeedPackage {
        let conceptIntro = ConceptIntro(concept: concept)
        let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: concept.id, strength: 0)
        let conceptIntroPackage = FeedPackage(feedPackageType: .conceptIntro, exercises: exercises, transitionItem: conceptIntro)
        return conceptIntroPackage
    }
    
    private func allConceptsHaveStrengthTwoPlus(conceptArray: [UserConcept]) -> Bool {
        let strengthLessThanTwoCount = conceptArray.reduce(0) { $0 + ($1.strength < 2 ? 1 : 0) }
        return (strengthLessThanTwoCount > 0)
    }
    
    private func getExercises_prior() -> FeedPackage {
        let exercises = exerciseSetCalculator.getExercisesTwoConcepts(concept1_id: Concept.constantRule.id, concept2_id: Concept.linearRule.id)
        return FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
    }
    
    func getExercise(id: Int) -> Exercise {
        let exercise = databaseService.getExercise(id: id)
        return exercise ?? Exercise.exercise1
    }
}
