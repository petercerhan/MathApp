//
//  FakeLoadExercisesViewModelDelegate.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeLoadExercisesViewModelDelegate: LoadExercisesViewModelDelegate {
    
    var next_callCount = 0
    
    func next(_ loadExercisesViewModel: LoadExercisesViewModel) {
        next_callCount += 1
    }
    
}
