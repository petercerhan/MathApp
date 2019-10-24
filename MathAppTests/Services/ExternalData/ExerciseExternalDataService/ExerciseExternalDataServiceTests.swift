//
//  ExerciseExternalDataServiceTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import MathApp

class ExerciseExternalDataServiceTests: XCTestCase {
    
    func test_getExercises_shouldRequestExercisesFromController() {
        let mockExerciseController = FakeExerciseController()
        let eds = ExerciseExternalDataServiceImpl(exerciseController: mockExerciseController)
        
        let _ = eds.getNext()
        
        XCTAssertEqual(mockExerciseController.getExercises_callCount, 1)
    }
    
}
