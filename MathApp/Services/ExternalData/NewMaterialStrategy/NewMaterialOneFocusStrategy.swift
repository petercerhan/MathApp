//
//  FeedPackageStrategy.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class NewMaterialOneFocusStrategy {
    
    //MARK: - Dependencies
    
    private let exerciseSetCalculator: ExerciseSetCalculator
    
    //MARK: - Config
    
    private let enrichedUserConcept: EnrichedUserConcept
    var concept: Concept {
        return enrichedUserConcept.userConcept.concept
    }
    var strength: Int {
        return enrichedUserConcept.userConcept.strength
    }
    
    //MARK: - Initialization
    
    init(exerciseSetCalculator: ExerciseSetCalculator, enrichedUserConcept: EnrichedUserConcept) {
        self.exerciseSetCalculator = exerciseSetCalculator
        self.enrichedUserConcept = enrichedUserConcept
    }
    
    //MARK: - StandardFeedPackageStrategy
    
    func getFeedPackage() -> FeedPackage {
        
        print("default standard strategy get feed package")
        
        if strength == 0 {
            return level0FeedPackage()
        } else {
            return level1PlusFeedPackage()
        }
    }
    
    private func level0FeedPackage() -> FeedPackage {
        if enrichedUserConcept.status == .unseen {
            print("concept intro for concept \(concept.id)")

            let conceptIntro = ConceptIntro(concept: concept)
            
            //should actually be exercises for previous concept, (if none, no exercises (will this work?))
            
            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: concept.id)
            let feedPackage = FeedPackage(feedPackageType: .conceptIntro, exercises: exercises, transitionItem: conceptIntro)
            return feedPackage
        }
        else if enrichedUserConcept.currentScore >= 5 {
            print("level up for concept \(concept.id)")
            
            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: concept.id)
            let levelUpItem = LevelUpItem(concept: concept, previousLevel: strength, newLevel: strength + 1)
            let feedPackage = FeedPackage(feedPackageType: .levelUp, exercises: exercises, transitionItem: levelUpItem)
            return feedPackage
        }
        else {
            print("single concept exercises for concept \(concept.id)")
            
            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: concept.id)
            let feedPackage = FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
            return feedPackage
        }
    }
    
    private func level1PlusFeedPackage() -> FeedPackage {
        
        print("\n\nlevel1PlusFeedPackage strength: \(strength)")
        
        print("single concept exercises for concept \(concept.id)")
        if enrichedUserConcept.currentScore < 5 {
            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: concept.id)
            let feedPackage = FeedPackage(feedPackageType: .exercises, exercises: exercises, transitionItem: nil)
            return feedPackage
        } else {
            let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: concept.id)
            let levelUpItem = LevelUpItem(concept: concept, previousLevel: strength, newLevel: strength + 1)
            let feedPackage = FeedPackage(feedPackageType: .levelUp, exercises: exercises, transitionItem: levelUpItem)
            return feedPackage
        }
    }
    
    private let emptyPackage = FeedPackage(feedPackageType: .exercises, exercises: [], transitionItem: nil)
    
}
