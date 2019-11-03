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
    static func createStub(id1: Int = 1, id2: Int = 2) -> PracticeTwoConceptsLearningStep {
        return PracticeTwoConceptsLearningStep(userConcept1: UserConcept.createStub(concept: Concept.constantRule, strength: 1),
                                               userConcept2: UserConcept.createStub(concept: Concept.linearRule, strength: 1))
    }
}
