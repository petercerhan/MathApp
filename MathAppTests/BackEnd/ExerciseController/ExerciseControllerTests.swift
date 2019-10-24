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
        let controller = ExerciseControllerImpl(userRepository: FakeUserRepository(), exerciseStrategyFactory: mockExerciseStrategyFactory)
        
        let _ = controller.getExercises()
        
        XCTAssertEqual(mockExerciseStrategyFactory.createStrategy_callCount, 1)
    }
    
}
