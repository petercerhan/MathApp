//
//  FakeLearningStepController.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/21/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeLearningStepController: LearningStepController {

    var nextLearningStepStub = ConceptIntroLearningStep(conceptID: 1)
    
    var nextLearningStep_callCount = 0
    
    func nextLearningStep() -> LearningStep {
        nextLearningStep_callCount += 1
        return nextLearningStepStub
    }
    
}
