//
//  LearningStepExternalDataServiceTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/21/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class LearningStepExternalDataServiceTests: XCTestCase {
    
    func test_getNext_shouldRequestNextStepFromController() {
        let mockLearningStepController = FakeLearningStepController()
        let eds = LearningStepExternalDataServiceImpl(learningStepController: mockLearningStepController)
        
        _ = eds.getNext()
        
        XCTAssertEqual(mockLearningStepController.nextLearningStep_callCount, 1)
    }
    
}
