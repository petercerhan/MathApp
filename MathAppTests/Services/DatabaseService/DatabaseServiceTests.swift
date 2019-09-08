//
//  DatabaseServiceTests.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import XCTest
@testable import MathApp

class DatabaseServiceTests: XCTestCase {
    
    func test_getUserConcepts_shouldReturnUserConcepts() {
        let databaseService = DatabaseServiceImpl()
        
        let userConcepts = databaseService.getUserConcepts()
        
        XCTAssertEqual(userConcepts.count, 1)
    }
    
}
