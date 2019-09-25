//
//  FakeChooseExerciseViewModelDelegate.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/24/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeChooseExerciseViewModelDelegate: ChooseExerciseViewModelDelegate {
    var back_callCount = 0
    
    func back(_ chooseExerciseViewModel: ChooseExerciseViewModel) {
        back_callCount += 1
    }
    
    var loadExercise_callCount = 0
    var loadExercise_id = [Int]()
    
    func loadExercise(_ chooseExerciseViewModel: ChooseExerciseViewModel, withID id: Int) {
        loadExercise_callCount += 1
        loadExercise_id.append(id)
    }
    
}
