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
    
    
    var incrementStrengthForUserConcept_callCount = 0
    var incrementStrengthForUserConcept_conceptID = [Int]()
    
    func incrementStrengthForUserConcept(withID conceptID: Int) {
        incrementStrengthForUserConcept_callCount += 1
        incrementStrengthForUserConcept_conceptID.append(conceptID)
    }
    
    
    var decrementStrengthForUserConcept_callCount = 0
    var decrementStrengthForUserConcept_conceptID = [Int]()
    
    func decrementStrengthForUserConcept(withID conceptID: Int) {
        decrementStrengthForUserConcept_callCount += 1
        decrementStrengthForUserConcept_conceptID.append(conceptID)
    }
    
    func reset() {
        
    }

}


