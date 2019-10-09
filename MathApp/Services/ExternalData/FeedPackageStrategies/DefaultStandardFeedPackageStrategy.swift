//
//  FeedPackageStrategy.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class DefaultStandardFeedPackageStrategy: StandardFeedPackageStrategy {
    
    //MARK: - Dependencies
    
    private let exerciseSetCalculator: ExerciseSetCalculator
    
    //MARK: - State
    
    private let enrichedUserConcept: EnrichedUserConcept
    
    //MARK: - Initialization
    
    init(exerciseSetCalculator: ExerciseSetCalculator, enrichedUserConcept: EnrichedUserConcept) {
        self.exerciseSetCalculator = exerciseSetCalculator
        self.enrichedUserConcept = enrichedUserConcept
    }
    
    //MARK: - StandardFeedPackageStrategy
    
    func getFeedPackage() -> FeedPackage {
        let concept = enrichedUserConcept.userConcept.concept
        let strength = enrichedUserConcept.userConcept.strength
        
        if enrichedUserConcept.status == .unseen {
            print("concept intro for concept \(concept.id)")

            let conceptIntro = ConceptIntro(concept: concept)
            
            //should actually be exercises for previous concept, (if none, no exercises (will this work?))
            
            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: concept.id, strength: strength)
            let feedPackage = FeedPackage(feedPackageType: .conceptIntro, exercises: exercises, transitionItem: conceptIntro)
            return feedPackage
        }
        else if enrichedUserConcept.status == .introductionInProgress, enrichedUserConcept.currentScore < 5 {
            print("single concept exercises for concept \(concept.id)")
            
            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: concept.id, strength: strength)
            let feedPackage = FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
            return feedPackage
        }
        
        if enrichedUserConcept.status == .introductionInProgress, enrichedUserConcept.currentScore >= 5 {
            print("level up for concept \(concept.id)")
            
            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: concept.id, strength: strength)
            let levelUpItem = LevelUpItem(concept: concept, previousLevel: strength, newLevel: strength + 1)
            let feedPackage = FeedPackage(feedPackageType: .levelUp, exercises: exercises, transitionItem: levelUpItem)
            return feedPackage
        }
        else {
            return emptyPackage
        }
    }
    
    private let emptyPackage = FeedPackage(feedPackageType: .exercises, exercises: [], transitionItem: nil)
    
}
