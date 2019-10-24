//
//  FakeDatabaseService.swift
//  MathAppTests
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite
@testable import MathApp

class FakeDatabaseService: DatabaseService {

    var db: Connection!

    //MARK: - setup
    
    var setup_callCount = 0
    
    func setup() {
        setup_callCount += 1
    }
    
    //MARK: - getUserConcepts
    
    var stubUserConcepts = [UserConcept]()
    
    func getUserConcepts() -> [UserConcept] {
        return stubUserConcepts
    }
    
    //MARK: - incementStrengthForUserConcept
    
    var incrementStrengthForUserConcept_callCount = 0
    var incrementStrengthForUserConcept_conceptID = [Int]()
    
    func incrementStrengthForUserConcept(conceptID: Int) {
        incrementStrengthForUserConcept_callCount += 1
        incrementStrengthForUserConcept_conceptID.append(conceptID)
    }
    
    //MARK: - decrementStrenthForUserConcept
    
    var decrementStrengthForUserConcept_callCount = 0
    var decrementStrengthForUserConcept_conceptID = [Int]()
    
    func decrementStrengthForUserConcept(conceptID: Int) {
        decrementStrengthForUserConcept_callCount += 1
        decrementStrengthForUserConcept_conceptID.append(conceptID)
    }
    
    //MARK: - getExercises(forConceptID: )
    
    var getExercises_stubData = [Exercise]()
    
    func getExercises(forConceptID conceptID: Int) -> [Exercise] {
        return getExercises_stubData
    }
    
    //MARK: - getExercise(id: )
    
    func getExercise(id: Int) -> Exercise? {
        return nil
    }
    
    //MARK: - reset
    
    var reset_callCount = 0
    func reset() {
        reset_callCount += 1
    }
    
    //MARK: - getFocusConcepts
    
    var getFocusConcepts_stub = (0, 0)
    func getFocusConcepts() -> (Int, Int) {
        return getFocusConcepts_stub
    }
    
    //MARK: - setUserConceptStatus(_ : forID: )
    
    var setUserConceptStatus_callCount = 0
    var setUserConceptStatus_status = [Int]()
    var setUserConceptStatus_id = [Int]()
    func setUserConceptStatus(_ status: Int, forConceptID id: Int) {
        setUserConceptStatus_callCount += 1
        setUserConceptStatus_status.append(status)
        setUserConceptStatus_id.append(id)
    }
    
    //MARK: - setFocusConcepts(concept1: concept2: )
    
    var setFocusConcepts_callCount = 0
    var setFocusConcepts_concept1 = [Int]()
    var setFocusConcepts_concept2 = [Int]()
    func setFocusConcepts(concept1: Int, concept2: Int) {
        setFocusConcepts_callCount += 1
        setFocusConcepts_concept1.append(concept1)
        setFocusConcepts_concept2.append(concept2)
    }
}

