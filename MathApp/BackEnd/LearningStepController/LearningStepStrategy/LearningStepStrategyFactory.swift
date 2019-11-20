//
//  LearningStepStrategyFactory.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation

protocol LearningStepStrategyFactory {
    func getStrategy(learningStrategy: LearningStrategy) -> LearningStepStrategy
}

class LearningStepStrategyFactoryImpl: LearningStepStrategyFactory {
    
    //MARK: - Dependencies
    
    private let userConceptRepository: UserConceptRepository
    private let newMaterialStateRepository: NewMaterialStateRepository
    private let userRepository: UserRepository
    private let userConceptGroupRepository: UserConceptGroupRepository
    private let conceptDetailGlyphRepository: ConceptDetailGlyphRepository
    
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
    }
    
    //MARK: - LearningStepStrategyFactory Interface
    
    func getStrategy(learningStrategy: LearningStrategy) -> LearningStepStrategy {
        return NewMaterialLearningStepStrategy(userConceptRepository: userConceptRepository,
                                               newMaterialStateRepository: newMaterialStateRepository,
                                               userRepository: userRepository,
                                               userConceptGroupRepository: userConceptGroupRepository,
                                               conceptDetailGlyphRepository: conceptDetailGlyphRepository)
    }
    
}
