//
//  FakeExerciseService.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeExerciseService: ExerciseService {
    func nextExercise() -> Exercise {
        return Exercise.exercise1
    }
}
