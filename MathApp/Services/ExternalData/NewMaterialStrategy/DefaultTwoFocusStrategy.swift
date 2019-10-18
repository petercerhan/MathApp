//
//  DefaultTwoFocusStrategy.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/15/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class DefaultTwoFocusStrategy: TwoFocusStrategy {
    
    //MARK: - Dependencies
    
    private let exerciseSetCalculator: ExerciseSetCalculator
    
    //MARK: - Config
    
    private let enrichedUserConcept1: EnrichedUserConcept
    private let enrichedUserConcept2: EnrichedUserConcept
    
    private var concept1: Concept {
        return enrichedUserConcept1.userConcept.concept
    }
    private var concept2: Concept {
        return enrichedUserConcept2.userConcept.concept
    }
    
    private var concept1Score: Int {
        return enrichedUserConcept1.currentScore
    }
    private var concept2Score: Int {
        return enrichedUserConcept2.currentScore
    }
    
    private var concept1ID: Int {
        return enrichedUserConcept1.userConcept.concept.id
    }
    private var concept2ID: Int {
        return enrichedUserConcept2.userConcept.concept.id
    }
    
    //MARK: - Initialization
    
    init(exerciseSetCalculator: ExerciseSetCalculator,
         enrichedUserConcept1: EnrichedUserConcept,
         enrichedUserConcept2: EnrichedUserConcept)
    {
        self.exerciseSetCalculator = exerciseSetCalculator
        self.enrichedUserConcept1 = enrichedUserConcept1
        self.enrichedUserConcept2 = enrichedUserConcept2
    }
    
    func getFeedPackage() -> FeedPackage {
        if concept1Score >= 5 {
            return levelUpPackage(concept: concept1, strength: enrichedUserConcept1.userConcept.strength)
        }
        else if concept2Score >= 5 {
            return levelUpPackage(concept: concept2, strength: enrichedUserConcept2.userConcept.strength)
        }
        
        let exercises = exerciseSetCalculator.getExercisesTwoConcepts(concept1_id: concept1ID, concept2_id: concept2ID)
        return FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
    }
    
    private func levelUpPackage(concept: Concept, strength: Int) -> FeedPackage {
        let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: concept.id, strength: strength)
        let levelUpItem = LevelUpItem(concept: concept, previousLevel: strength, newLevel: strength + 1)
        return FeedPackage(feedPackageType: .levelUp, exercises: exercises, transitionItem: levelUpItem)
    }
    
}
