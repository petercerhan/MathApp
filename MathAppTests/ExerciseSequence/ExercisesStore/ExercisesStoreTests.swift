//
//  ExercisesStoreTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/12/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import RxSwift
import XCTest
@testable import MathApp

class ExercisesStoreTests: XCTestCase {
    
    private let disposeBag = DisposeBag()
    
    func test_updateExercises_reqeustsNewExercises() {
        let mockExerciseExternalDataService = FakeExerciseExternalDataService()
        let exerciseStore = ExercisesStoreImpl(exerciseExternalDataService: mockExerciseExternalDataService)
        
        exerciseStore.dispatch(action: .updateExercises)
        
        XCTAssertEqual(mockExerciseExternalDataService.getExercises_callCount, 1)
    }
    
    func test_updateExercises_externalDataReturnsThreeExercises_shouldEmitThreeExercises() {
        let stubExerciseExternalDataService = FakeExerciseExternalDataService()
        stubExerciseExternalDataService.getExercises_stubData = [Exercise.exercise1, Exercise.exercise2, Exercise.exercise3]
        let exerciseStore = ExercisesStoreImpl(exerciseExternalDataService: stubExerciseExternalDataService)
        
        exerciseStore.dispatch(action: .updateExercises)
        
        guard let exercises = latestValue(of: exerciseStore.exercises, disposeBag: disposeBag) else {
            XCTFail("Could not get exercises")
            return
        }
        XCTAssertEqual(exercises.count, 3)
    }
    
}



