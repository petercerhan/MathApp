//
//  UserConceptExternalDataService.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 10/26/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class UserConceptExternalDataServiceTests: XCTestCase {
    
    func test_update_shouldCallUpdateOnController() {
        let mockController = FakeUserConceptController()
        let eds = UserConceptExternalDataServiceImpl(userConceptController: mockController)
        
        eds.update(id: 1, fields: ["strength": "1"])
        
        XCTAssertEqual(mockController.update_callCount, 1)
    }
    
    func test_listByChapter_shouldCallByChapterListOnController() {
        let mockController = FakeUserConceptController()
        let eds = UserConceptExternalDataServiceImpl(userConceptController: mockController)
        
        let _ = eds.list(chapterID: 1)
        
        XCTAssertEqual(mockController.list_chapterID_callCount, 1)
    }
}
