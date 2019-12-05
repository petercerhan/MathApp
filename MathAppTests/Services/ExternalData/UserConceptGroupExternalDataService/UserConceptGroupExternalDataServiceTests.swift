//
//  UserConceptGroupExternalDataServiceTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 12/4/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class UserConceptGroupExternalDataServiceTests: XCTestCase {
    
    func test_listByChapter_shouldCallListByChapterOnController() {
        let mockController = FakeUserConceptGroupController()
        let eds = UserConceptGroupExternalDataServiceImpl(userConceptGroupController: mockController)
        
        let _ = eds.list(chapterID: 1)
        
        XCTAssertEqual(mockController.listByChapter_callCount, 1)
    }
    
}
