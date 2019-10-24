//
//  FakeExerciseController.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeExerciseController: ExerciseController {
    
    var getExercises_callCount = 0
    
    func getExercises() -> [Exercise] {
        getExercises_callCount += 1
        return []
    }
}
