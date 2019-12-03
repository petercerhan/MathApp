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
        
        let _ = eds.getNext(conceptIDs: [1])
        
        XCTAssertEqual(mockExerciseController.getExercises_conceptIDs_callCount, 1)
    }
    
    func test_getExercise_shouldRequestExerciseFromController() {
        let mockExerciseController = FakeExerciseController()
        let eds = ExerciseExternalDataServiceImpl(exerciseController: mockExerciseController)
        
        let _ = eds.get(id: 2)
        
        XCTAssertEqual(mockExerciseController.getExercise_callCount, 1)
        XCTAssertEqual(mockExerciseController.getExercise_id.first, 2)
    }
    
}
