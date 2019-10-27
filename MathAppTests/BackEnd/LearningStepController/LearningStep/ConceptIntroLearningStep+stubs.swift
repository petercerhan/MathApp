//
//  ConceptIntroLearningStep+stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/22/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension ConceptIntroLearningStep {
    static func createStub() -> ConceptIntroLearningStep {
        let userConcept = UserConcept.createStub()
        return ConceptIntroLearningStep(userConcept: userConcept)
    }
    
    static func createWithConceptID(conceptID: Int) -> ConceptIntroLearningStep {
        let userConcept = UserConcept.createStub(concept: Concept.createStub(id: conceptID))
        return ConceptIntroLearningStep(userConcept: userConcept)
    }
    
    static func createWithConcept(concept: Concept) -> ConceptIntroLearningStep {
        let userConcept = UserConcept.createStub(concept: concept)
        return ConceptIntroLearningStep(userConcept: userConcept)
    }
}
