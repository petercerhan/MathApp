//
//  ExerciseControllerTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/23/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class ExerciseControllerTests: XCTestCase {
    
    func test_getExercises_shouldRequestExercisesStrategyFromFactory() {
        let mockExerciseStrategyFactory = FakeExerciseStrategyFactory()
        let controller = composeSUT(fakeExerciseStrategyFactory: mockExerciseStrategyFactory)
        
        let _ = controller.getExercises(conceptIDs: [1])
        
        XCTAssertEqual(mockExerciseStrategyFactory.createStrategy_callCount, 1)
    }
    
    func test_getExercisesWithConceptIDs_shouldRequestExercisesStrategyFromFactory() {
        let mockExerciseStrategyFactory = FakeExerciseStrategyFactory()
        let controller = composeSUT(fakeExerciseStrategyFactory: mockExerciseStrategyFactory)
        
        let _ = controller.getExercises(conceptIDs: [1,2])
        
        XCTAssertEqual(mockExerciseStrategyFactory.createStrategy_callCount, 1)
    }
    
    func test_getExerciseByID_shouldGetExerciseFromRepository() {
        let mockRepository = FakeExerciseRepository()
        let controller = composeSUT(fakeExerciseRepository: mockRepository)
        
        let _ = controller.getExercise(id: 1)
        
        XCTAssertEqual(mockRepository.get_callCount, 1)
    }
    
    private func composeSUT(fakeUserRepository: FakeUserRepository = FakeUserRepository(),
                            fakeExerciseStrategyFactory: FakeExerciseStrategyFactory = FakeExerciseStrategyFactory(),
                            fakeExerciseRepository: FakeExerciseRepository = FakeExerciseRepository()) -> ExerciseController
    {
        return ExerciseControllerImpl(userRepository: fakeUserRepository,
                                      exerciseStrategyFactory: fakeExerciseStrategyFactory,
                                      exerciseRepository: fakeExerciseRepository)
    }
    
}
