//
//  FakeDatabaseService.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
@testable import MathApp

class FakeDatabaseService: DatabaseService {
    
    var setup_callCount = 0
    
    func setup() {
        setup_callCount += 1
    }
    
    var stubUserConcepts = [UserConcept]()
    
    func getUserConcepts() -> [UserConcept] {
        return stubUserConcepts
    }
}
