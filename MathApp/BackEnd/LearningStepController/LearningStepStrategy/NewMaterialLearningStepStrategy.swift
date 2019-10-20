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
    
    //MARK: - Initialization
    
    init(userConceptRepository: UserConceptRepository) {
        self.userConceptRepository = userConceptRepository
    }
    
    func nextLearningStep() -> LearningStep {
        return ConceptIntroLearningStep(conceptID: 1)
    }
    
}
