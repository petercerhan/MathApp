//
//  NewMaterialLearningStepStrategy.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

class NewMaterialLearningStepStrategy: LearningStepStrategy {
    
    //MARK: - Dependencies
    
    private let userConceptRepository: UserConceptRepository
    private let newMaterialStateRepository: NewMaterialStateRepository
    private let userRepository: UserRepository
    
    //MARK: - Context
    
    private let focus1ID: Int
    private let focus2ID: Int
    private var userConcept1: UserConcept? = nil
    private var userConcept2: UserConcept? = nil
    
    //MARK: - Initialization
    
    init(userConceptRepository: UserConceptRepository,
         newMaterialStateRepository: NewMaterialStateRepository,
         userRepository: UserRepository)
    {
        self.userConceptRepository = userConceptRepository
        self.newMaterialStateRepository = newMaterialStateRepository
        self.userRepository = userRepository
        
        let newMaterialLearningStep = newMaterialStateRepository.get()
        focus1ID = newMaterialLearningStep.focusConcept1ID
        focus2ID = newMaterialLearningStep.focusConcept2ID
        findNextUserConcepts()
    }
    
    private func findNextUserConcepts() {
        let userConcepts = userConceptRepository.list()
        
        guard let userConcept1_index = userConcepts.firstIndex(where: { $0.strength == 0 || $0.strength == 1 }) else {
            return
        }
        userConcept1 = userConcepts[userConcept1_index]
        
        var searchUserConcept2 = userConcepts
        searchUserConcept2.remove(at: userConcept1_index)
        if searchUserConcept2.count > 0 {
            userConcept2 = searchUserConcept2.first(where: { $0.strength == 0 || $0.strength == 1 })
        }
        
    }
    
    //MARK: - LearningStepStrategy Interface
    
    func nextLearningStep() -> LearningStep {
        guard let userConcept1 = userConcept1 else {
            return practiceFamilyLearningStep()
        }
        
        if userConcept1.strength == 0 {
            newMaterialStateRepository.setFocus(concept1ID: userConcept1.conceptID, concept2ID: 0)
            return ConceptIntroLearningStep(userConcept: userConcept1)
        }
        
        if let nextStep = learningStepForContinuedTwoConceptPractice(userConcept1: userConcept1) {
            newMaterialStateRepository.setFocus(concept1ID: userConcept1.conceptID, concept2ID: 0)
            return nextStep
        }
        
        if let nextStep = learningStepForSecondStrength0(userConcept1: userConcept1) {
            let conceptID = userConcept2?.conceptID ?? 0
            newMaterialStateRepository.setFocus(concept1ID: conceptID, concept2ID: 0)
            return nextStep
        }
        
        if let nextStep = learningStepForSecondStrength1(userConcept1: userConcept1) {
            let concept2ID = userConcept2?.conceptID ?? 0
            newMaterialStateRepository.setFocus(concept1ID: userConcept1.conceptID, concept2ID: concept2ID)
            return nextStep
        }
        
        return practiceFamilyLearningStep()
    }
    
    private func learningStepForContinuedTwoConceptPractice(userConcept1: UserConcept) -> LearningStep? {
        if userConcept1.strength == 1,
            userConceptIsContinuedFromTwoConceptPractice(userConcept1)
        {
            return PracticeOneConceptLearningStep(conceptID: userConcept1.conceptID)
        } else {
            return nil
        }
    }
    
    private func userConceptIsContinuedFromTwoConceptPractice(_ userConcept: UserConcept) -> Bool {
        return (userConcept.conceptID == focus1ID || userConcept.conceptID == focus2ID)
    }
    
    private func learningStepForSecondStrength0(userConcept1: UserConcept) -> LearningStep? {
        if userConcept1.strength == 1,
            let userConcept2 = userConcept2,
            userConcept2.strength == 0
        {
            return ConceptIntroLearningStep(userConcept: userConcept2)
        } else {
            return nil
        }
    }
    
    private func learningStepForSecondStrength1(userConcept1: UserConcept) -> LearningStep? {
        if userConcept1.strength == 1, let userConcept2 = userConcept2, userConcept2.strength == 1 {
            return PracticeTwoConceptsLearningStep(concept1ID: userConcept1.conceptID, concept2ID: userConcept2.conceptID)
        } else {
            return nil
        }
    }
    
    private func practiceFamilyLearningStep() -> LearningStep {
        newMaterialStateRepository.reset()
        userRepository.setLearningStrategy(.practiceFamily)
        return PracticeFamilyLearningStep()
    }
    
}
