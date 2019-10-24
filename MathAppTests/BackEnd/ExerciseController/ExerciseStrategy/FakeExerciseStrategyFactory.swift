//
//  FakeExerciseStrategyFactory.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeExerciseStrategyFactory: ExerciseStrategyFactory {

    var createStrategy_callCount = 0

    func createStrategy(learningStrategy: LearningStrategy) -> ExerciseStrategy {
        createStrategy_callCount += 1
        return NewMaterialExerciseStrategy()
    }
    
    
}
