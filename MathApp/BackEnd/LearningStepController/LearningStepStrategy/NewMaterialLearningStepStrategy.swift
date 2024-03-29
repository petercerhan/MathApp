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
    private let userConceptGroupRepository: UserConceptGroupRepository
    private let conceptDetailGlyphRepository: ConceptDetailGlyphRepository
    
    //MARK: - Context

    private let conceptGroupID: Int
    private let focus1ID: Int
    private let focus2ID: Int
    private var userConcept1: UserConcept? = nil
    private var userConcept2: UserConcept? = nil
    
    //MARK: - Initialization
    
    init(userConceptRepository: UserConceptRepository,
         newMaterialStateRepository: NewMaterialStateRepository,
         userRepository: UserRepository,
         userConceptGroupRepository: UserConceptGroupRepository,
         conceptDetailGlyphRepository: ConceptDetailGlyphRepository)
    {
        self.userConceptRepository = userConceptRepository
        self.newMaterialStateRepository = newMaterialStateRepository
        self.userRepository = userRepository
        self.userConceptGroupRepository = userConceptGroupRepository
        self.conceptDetailGlyphRepository = conceptDetailGlyphRepository
        
        let newMaterialLearningStep = newMaterialStateRepository.get()
        conceptGroupID = newMaterialLearningStep.conceptGroupID
        focus1ID = newMaterialLearningStep.focusConcept1ID
        focus2ID = newMaterialLearningStep.focusConcept2ID
        findNextUserConcepts()
        addGlyphsToUserConcepts()
    }
    
    private func findNextUserConcepts() {
        let userConcepts = userConceptRepository.list(conceptGroupID: conceptGroupID)
        
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
    
    private func addGlyphsToUserConcepts() {
        if let conceptID = userConcept1?.conceptID {
            userConcept1?.concept.detailGlyphs = conceptDetailGlyphRepository.list(conceptID: conceptID)
        }
        if let conceptID = userConcept2?.conceptID {
            userConcept2?.concept.detailGlyphs = conceptDetailGlyphRepository.list(conceptID: conceptID)
        }
    }
    
    //MARK: - LearningStepStrategy Interface
    
    func nextLearningStep() -> LearningStep {
        guard let userConcept1 = userConcept1 else {
            return transitionLearningStep()
        }

        if userConcept1.strength == 0 {
            newMaterialStateRepository.setFocus(concept1ID: userConcept1.conceptID, concept2ID: 0)
            return ConceptIntroLearningStep(userConcept: userConcept1)
        }
        
        if userConcept1.strength == 1, userConcept2 == nil {
            newMaterialStateRepository.setFocus(concept1ID: userConcept1.conceptID, concept2ID: 0)
            return PracticeOneConceptLearningStep(userConcept: userConcept1)
        }
        
        if let nextStep = learningStepForContinuedTwoConceptPractice(userConcept1: userConcept1, concept2ID: userConcept2?.conceptID) {
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
        
        return transitionLearningStep()
    }
    
    private func learningStepForContinuedTwoConceptPractice(userConcept1: UserConcept, concept2ID: Int?) -> LearningStep? {
        if userConcept1.strength == 1,
            userConceptIsContinuedFromTwoConceptPractice(userConcept1, concept2ID: concept2ID)
        {
            return PracticeOneConceptLearningStep(userConcept: userConcept1)
        } else {
            return nil
        }
    }
    
    private func userConceptIsContinuedFromTwoConceptPractice(_ userConcept: UserConcept, concept2ID: Int?) -> Bool {
        if focus2ID == 0 {
            return false
        }
        let firstConceptIsFocussed = (userConcept.conceptID == focus1ID || userConcept.conceptID == focus2ID)
        if concept2ID == nil {
            return firstConceptIsFocussed
        } else {
            let secondConceptIsFocussed = (concept2ID! == focus1ID || concept2ID! == focus2ID)
            return firstConceptIsFocussed && !secondConceptIsFocussed
        }
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
        if userConcept1.strength == 1,
            let userConcept2 = userConcept2,
            userConcept2.strength == 1
        {
            return PracticeTwoConceptsLearningStep(userConcept1: userConcept1,
                                                   userConcept2: userConcept2)
        } else {
            return nil
        }
    }
    
    private func transitionLearningStep() -> LearningStep {
        let newMaterialState = newMaterialStateRepository.get()
        let userConceptGroups = userConceptGroupRepository.list().sorted { $0.id < $1.id }
        let nextConceptGroup = userConceptGroups.first(where: { $0.conceptGroupID > newMaterialState.conceptGroupID && $0.completed == false })
        let currentUserConceptGroup = userConceptGroups.first(where: { $0.conceptGroupID == newMaterialState.conceptGroupID })
        
        if let nextGroup = nextConceptGroup?.conceptGroup,
            let currentUserConceptGroup = currentUserConceptGroup
        {
            userConceptGroupRepository.set(id: currentUserConceptGroup.id, fields: ["completed": "1"])
            newMaterialStateRepository.resetForNewConceptGroup(conceptGroupID: nextGroup.id)

            return TransitionLearningStep(transitionItems: [GroupCompleteTransitionItem(completedConceptGroup: currentUserConceptGroup.conceptGroup,
                                                                                        nextConceptGroup: nextGroup)])
        } else {
            return practiceFamilyLearningStep()
        }
    }
    
    private func practiceFamilyLearningStep() -> LearningStep {
        newMaterialStateRepository.reset()
        userRepository.setLearningStrategy(.practiceFamily)
        return PracticeFamilyLearningStep(conceptIDs: [1,2,3,4,5])
    }
    
}
