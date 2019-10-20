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
    
    //MARK: - Initialization
    
    init(userConceptRepository: UserConceptRepository, newMaterialStateRepository: NewMaterialStateRepository) {
        self.userConceptRepository = userConceptRepository
        self.newMaterialStateRepository = newMaterialStateRepository
    }
    
    //MARK: - LearningStepStrategy Interface
    
    func nextLearningStep() -> LearningStep {
        let userConcepts = userConceptRepository.list()
        let newMaterialLearningStep = newMaterialStateRepository.get()
        let focus1ID = newMaterialLearningStep.focusConcept1ID
        let focus2ID = newMaterialLearningStep.focusConcept2ID
        
        guard let userConcept1_index = userConcepts.firstIndex(where: { $0.strength == 0 || $0.strength == 1 }) else {
            #warning("Should return practice family")
            return ConceptIntroLearningStep(conceptID: 1)
        }
        
        //get user concepts
        let userConcept1 = userConcepts[userConcept1_index]
        var searchUserConcept2 = userConcepts
        searchUserConcept2.remove(at: userConcept1_index)
        var userConcept2: UserConcept?
        if searchUserConcept2.count > 0 {
            userConcept2 = searchUserConcept2.first(where: { $0.strength == 0 || $0.strength == 1 })
        }
        
        if focus2ID != 0,
            userConcept1.strength == 1,
            let userConcept2 = userConcept2,
            (userConcept1.conceptID == focus1ID || userConcept1.conceptID == focus2ID),
            (userConcept2.conceptID != focus1ID && userConcept2.conceptID != focus2ID)
        {
            return PracticeOneConceptLearningStep(conceptID: userConcept1.conceptID)
        }
        
        if userConcept1.strength == 0 {
            return ConceptIntroLearningStep(conceptID: 1)
        }
        
        
        if userConcept1.strength == 1, let userConcept2 = userConcept2 {
            
            if userConcept2.strength == 0 {
                return ConceptIntroLearningStep(conceptID: userConcept2.id)
            }
        }
        
        return ConceptIntroLearningStep(conceptID: 1)
    }
    
}
