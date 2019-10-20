//
//  LearningStepControllerTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class LearningStepControllerTests: XCTestCase {
    
    func test_getLearningStep_newMaterialStrategy_shouldRequestNewMaterialLearningStepStrategy() {
        let mockLearningStepStrategyFactory = FakeLearningStepStrategyFactory()
        let controller = LearningStepController(learningStepStrategyFactory: mockLearningStepStrategyFactory)
        
        let _ = controller.nextLearningStep()
        
        XCTAssertEqual(mockLearningStepStrategyFactory.getStrategy_callCount, 1)
        XCTAssertEqual(mockLearningStepStrategyFactory.getStrategy_learningStrategy.first, .newMaterial)
    }
    
}
