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
        let concept = Concept.createStub(id: 1)
        return ConceptIntroLearningStep(conceptIntro: ConceptIntro(concept: concept))
    }
    
    static func createWithConceptID(conceptID: Int) -> ConceptIntroLearningStep {
        let concept = Concept.createStub(id: conceptID)
        return ConceptIntroLearningStep(conceptIntro: ConceptIntro(concept: concept))
    }
}
