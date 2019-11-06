//
//  PracticeOneConceptLearningStep.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 11/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

extension PracticeOneConceptLearningStep {
    static func createStub(concept: Concept? = nil) -> PracticeOneConceptLearningStep {
        return PracticeOneConceptLearningStep(userConcept: UserConcept(id: 1, concept: concept ?? Concept.constantRule, strength: 1))
    }
}
