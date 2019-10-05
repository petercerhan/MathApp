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
    
    //MARK: - recordResult(concept_id: correct: )
    
    var recordResult_callCount = 0
    var recordResult_concept_id = [Int]()
    var recordResult_correct = [Bool]()
    
    func recordResult(concept_id: Int, correct: Bool) {
        recordResult_callCount += 1
        recordResult_concept_id.append(concept_id)
        recordResult_correct.append(correct)
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
    
    //MARK: - getEnrichedUserConcept(conceptID: )
    
    var getEnrichedUserConcept_stub: EnrichedUserConcept?
    func getEnrichedUserConcept(conceptID: Int) -> EnrichedUserConcept? {
        return getEnrichedUserConcept_stub
    }
    
    //MARK: - setUserConceptStatus(_ : forID: )
    
    var setUserConceptStatus_callCount = 0
    var setUserConceptStatus_status = [Int]()
    var setUserConceptStatus_id = [Int]()
    func setUserConceptStatus(_ status: Int, forID id: Int) {
        setUserConceptStatus_callCount += 1
        setUserConceptStatus_status.append(status)
        setUserConceptStatus_id.append(id)
    }
}

