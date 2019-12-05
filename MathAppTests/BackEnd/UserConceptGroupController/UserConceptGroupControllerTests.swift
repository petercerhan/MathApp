//
//  UserConceptGroupControllerTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 12/4/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class UserConceptGroupControllerTests: XCTestCase {
    
    func test_listByChapter_shouldRequestListByChapter() {
        let mockUserConceptGroupRepository = FakeUserConceptGroupRepository()
        let userConceptGroupController = UserConceptGroupControllerImpl(userConceptGroupRepository: mockUserConceptGroupRepository)
        
        let _ = userConceptGroupController.list(chapterID: 1)
        
        XCTAssertEqual(mockUserConceptGroupRepository.listByChapter_callCount, 1)
    }
    
}
