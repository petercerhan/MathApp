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
    
    //MARK: - Context
    
    private let focus1ID: Int
    private let focus2ID: Int
    private var userConcept1: UserConcept? = nil
    private var userConcept2: UserConcept? = nil
    
    //MARK: - Initialization
    
    init(userConceptRepository: UserConceptRepository, newMaterialStateRepository: NewMaterialStateRepository) {
        self.userConceptRepository = userConceptRepository
        self.newMaterialStateRepository = newMaterialStateRepository
        
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
            #warning("Should return practice family")
            return ConceptIntroLearningStep(conceptID: 1)
        }
        
        if let nextStep = learningStepForContinuedTwoConceptPractice(userConcept1: userConcept1) {
            return nextStep
        }
        
        if userConcept1.strength == 0 {
            return ConceptIntroLearningStep(conceptID: 1)
        }
        
        if let nextStep = learningStepForSecondStrength0(userConcept1: userConcept1) {
            return nextStep
        }
        
        return ConceptIntroLearningStep(conceptID: 1)
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
        if userConcept1.strength == 1, let userConcept2 = userConcept2, userConcept2.strength == 0 {
            return ConceptIntroLearningStep(conceptID: userConcept2.id)
        } else {
            return nil
        }
    }
    
}
