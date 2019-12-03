//
//  FakeExerciseRepository.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeExerciseRepository: ExerciseRepository {
    
    var list_callCount = 0
    
    func list(conceptID: Int) -> [Exercise] {
        list_callCount += 1
        return []
    }
    
    
    var get_callCount = 0
    
    func get(id: Int) -> Exercise? {
        get_callCount += 1
        return nil
    }
    
}
