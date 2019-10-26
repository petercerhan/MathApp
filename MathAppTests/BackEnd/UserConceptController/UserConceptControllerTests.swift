//
//  UserConceptControllerTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class UserConceptControllerTests: XCTestCase {
    
    func test_update_shouldRequestUpdate() {
        let mockUserConceptRepository = FakeUserConceptRepository()
        let userConceptController = UserConceptControllerImpl(userConceptRepository: mockUserConceptRepository)
        
        userConceptController.update(id: 1, fields: ["strength": "1"])
        
        XCTAssertEqual(mockUserConceptRepository.set_callCount, 1)
    }
    
    
}
