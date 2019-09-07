//
//  FakeExerciseViewModelDelegate.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 8/29/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

@testable import MathApp

class FakeExerciseViewModelDelegate: ExerciseViewModelDelegate {
    
    var next_callCount = 0
    func next(_ exerciseViewModel: ExerciseViewModel) {
        next_callCount += 1
    }
    
    var info_callCount = 0
    func info(_ exerciseViewModel: ExerciseViewModel, concept: Concept) {
        info_callCount += 1
    }
}
