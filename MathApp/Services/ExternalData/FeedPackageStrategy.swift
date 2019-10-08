//
//  FeedPackageStrategy.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class FeedPackageStrategy {
    
    //MARK: - Dependencies
    
    private let exerciseSetCalculator: ExerciseSetCalculator
    
    //MARK: - Initialization
    
    init(exerciseSetCalculator: ExerciseSetCalculator) {
        self.exerciseSetCalculator = exerciseSetCalculator
    }
    
    func getNextFeedPackage(concept1_id: Int, concept2_id: Int, enrichedUserConcept_1: EnrichedUserConcept) -> FeedPackage {
        if concept2_id == 0 {
            return getSingleFocusFeedPackage(conceptID: concept1_id)
        }
    }
    
    private func getSingleFocusFeedPackage(conceptID: Int) -> FeedPackage {
        let concept = enrichedUserConcept_1.userConcept.concept
        let strength = enrichedUserConcept_1.userConcept.strength
        
        if enrichedUserConcept_1.status == .unseen {
            print("concept intro for concept \(conceptID)")

            let conceptIntro = ConceptIntro(concept: concept)
            
            //should actually be exercises for previous concept, (if none, no exercises (will this work?))
            
            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID:  enrichedUserConcept_1.userConcept.concept.id, strength: strength)
            let feedPackage = FeedPackage(feedPackageType: .conceptIntro, exercises: exercises, transitionItem: conceptIntro)
            return feedPackage
        }
        else if enrichedUserConcept_1.status == .introductionInProgress, enrichedUserConcept_1.currentScore < 5 {
            print("single concept exercises for concept \(conceptID)")
            
            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: conceptID, strength: strength)
            let feedPackage = FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
            return feedPackage
        }
        
        if enrichedUserConcept_1.status == .introductionInProgress, enrichedUserConcept_1.currentScore >= 5 {
            print("level up for concept \(enrichedUserConcept_1.userConcept.concept.id)")
            
            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: enrichedUserConcept_1.userConcept.concept.id, strength: enrichedUserConcept_1.userConcept.strength)
            let levelUpItem = LevelUpItem(concept: concept, previousLevel: strength, newLevel: strength + 1)
            let feedPackage = FeedPackage(feedPackageType: .levelUp, exercises: exercises, transitionItem: levelUpItem)
            return feedPackage
        }
    }
    
}
