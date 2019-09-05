//
//  ExerciseServiceTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/5/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import UIKit
import XCTest
@testable import MathApp

class ExerciseServiceTests: XCTestCase {
    
    func test_requestExercise_incrementsNextExerciseIndex() {
        let exerciseService = ExerciseServiceImpl()
        
        _ = exerciseService.nextExercise()
        
        XCTAssertEqual(exerciseService.exerciseIndex, 1)
    }
    
    
}
