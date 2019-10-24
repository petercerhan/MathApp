//
//  NewMaterialLevelUpStrategy.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class NewMaterialLevelUpStrategy {
    
    //MARK: - Dependencies
    
    private let databaseService: DatabaseService
    private let exerciseSetCalculator: ExerciseSetCalculator
    
    //MARK: - Context
    
    private let levelUpUserConcept: EnrichedUserConcept
    private var levelUpConceptID: Int {
        return levelUpUserConcept.userConcept.concept.id
    }
    private let familyUserConcepts: [EnrichedUserConcept]
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService,
         exerciseSetCalculator: ExerciseSetCalculator,
         levelUpUserConcept: EnrichedUserConcept,
         familyUserConcepts: [EnrichedUserConcept])
    {
        self.databaseService = databaseService
        self.exerciseSetCalculator = exerciseSetCalculator
        self.levelUpUserConcept = levelUpUserConcept
        self.familyUserConcepts = familyUserConcepts
    }
    
    //MARK: - NewMaterialLevelUpStrategy Interface
    
    func getFeedPackage() -> FeedPackage {
        incrementLevelUpConceptStrength()
        
        if levelUpUserConcept.userConcept.strength == 0 {
            setLevelUpConceptStatusComplete()
        }
        
        if familyConceptsContainUnseen() {
            return nextConceptIntroPackage()
        }
        
        return FeedPackage(feedPackageType: .exercises, exercises: [], transitionItem: nil)
    }
    
    private func incrementLevelUpConceptStrength() {
        databaseService.incrementStrengthForUserConcept(conceptID: levelUpConceptID)
    }
    
    private func setLevelUpConceptStatusComplete() {
        databaseService.setUserConceptStatus(EnrichedUserConcept.Status.introductionComplete.rawValue, forConceptID: levelUpConceptID)
    }
    
    private func familyConceptsContainUnseen() -> Bool {
        if let _ = familyUserConcepts.first(where: { $0.status == .unseen }) {
            return true
        } else {
            return false
        }
    }
    
    private func nextConceptIntroPackage() -> FeedPackage {
        let firstUnseen = familyUserConcepts.first(where: { $0.status == .unseen })!
        databaseService.setFocusConcepts(concept1: firstUnseen.userConcept.concept.id, concept2: 0)
        return assembleNextConceptIntroPackage(userConcept: firstUnseen)
    }
    
    private func assembleNextConceptIntroPackage(userConcept: EnrichedUserConcept) -> FeedPackage {
        let conceptIntro = ConceptIntro(concept: userConcept.userConcept.concept)
        let exercises = exerciseSetCalculator.getExercisesForConcept(conceptID: userConcept.userConcept.concept.id)
        let package = FeedPackage(feedPackageType: .conceptIntro, exercises: exercises, transitionItem: conceptIntro)
        return package
    }
    
    
    
}
