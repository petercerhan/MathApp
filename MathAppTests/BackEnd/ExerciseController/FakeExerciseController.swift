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
    
    var getExercises_conceptIDs_callCount = 0
    
    func getExercises(conceptIDs: [Int]) -> [Exercise] {
        getExercises_conceptIDs_callCount += 1
        return []
    }
    
    var getExercise_callCount = 0
    var getExercise_id = [Int]()
    
    func getExercise(id: Int) -> Exercise? {
        getExercise_callCount += 1
        getExercise_id.append(id)
        return nil
    }
    
}
