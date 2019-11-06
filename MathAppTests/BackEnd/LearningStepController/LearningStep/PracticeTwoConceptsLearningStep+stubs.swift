//
//  PracticeTwoConceptsLearningStep+stubs.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/29/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension PracticeTwoConceptsLearningStep {
    static func createStub(concept1: Concept? = nil, concept2: Concept? = nil) -> PracticeTwoConceptsLearningStep {
        return PracticeTwoConceptsLearningStep(userConcept1: UserConcept.createStub(concept: concept1 ?? Concept.constantRule, strength: 1),
                                               userConcept2: UserConcept.createStub(concept: concept2 ?? Concept.linearRule, strength: 1))
    }
}
