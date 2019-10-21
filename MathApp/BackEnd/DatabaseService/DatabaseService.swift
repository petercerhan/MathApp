//
//  DatabaseService.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/7/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

protocol DatabaseService {

    var db: Connection! { get }

    func setup()
    func reset()
    
    func getUserConcepts() -> [UserConcept]
    
    func incrementStrengthForUserConcept(conceptID: Int)
    func decrementStrengthForUserConcept(conceptID: Int)
    
    func getExercises(forConceptID conceptID: Int) -> [Exercise]
    func getExercise(id: Int) -> Exercise?
    
    func recordResult(concept_id: Int, correct: Bool)
    
    func getFocusConcepts() -> (Int, Int)
    func getEnrichedUserConcept(conceptID: Int) -> EnrichedUserConcept?
    
    func setUserConceptStatus(_ status: Int, forConceptID conceptID: Int)

    func setFocusConcepts(concept1: Int, concept2: Int)
}

class DatabaseServiceImpl: DatabaseService {
    
    private(set) var db: Connection!
    
    private let databaseFilename = "db.sqlite3"
    
    private lazy var conceptsTable = Concept.table
    private lazy var userConceptsTable = UserConcept.table
    private lazy var exerciseTable = Exercise.table
    
    func setup() {
        guard let bundleURL = Bundle.main.url(forResource: "db", withExtension: "sqlite3"),
            let documentsDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        else {
                return
        }
        let documentsURL = documentsDirectory.appendingPathComponent(databaseFilename)
        
        if !(FileManager().fileExists(atPath: documentsURL.absoluteString)) {
            try? FileManager.default.copyItem(at: bundleURL, to: documentsURL)
        }

        guard let db = try? Connection(documentsURL.absoluteString) else {
            return
        }
        self.db = db
    }
    
    func reset() {
        removeOldDB()
        setup()
    }
    
    private func removeOldDB() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: "\(path)/\(databaseFilename)")
    }
    
    func getUserConcepts() -> [UserConcept] {
        let query = conceptsTable.join(userConceptsTable, on: UserConcept.column_conceptID == conceptsTable[Concept.column_id])
        let result: [UserConcept]? = try? db.prepare(query).compactMap { row -> UserConcept? in
            return UserConcept.createFromQueryResult(row)
        }
        return result ?? [UserConcept]()
    }
    
    func incrementStrengthForUserConcept(conceptID: Int) {
        let userConceptQuery = userConceptsTable.filter(UserConcept.column_conceptID == Int64(conceptID))
        guard let userConceptRow = try? db.pluck(userConceptQuery) else {
            return
        }
        let priorStrength = userConceptRow[UserConcept.column_strength]
        let newStrength = min(priorStrength + 1, 3)
        let completeStatusCode = Int64(EnrichedUserConcept.Status.introductionComplete.rawValue)
        
        _ = try? db.run(userConceptQuery.update(UserConcept.column_strength <- newStrength,
                                                UserConcept.column_status <- completeStatusCode,
                                                UserConcept.column_exercise_result_0 <- 0,
                                                UserConcept.column_exercise_result_1 <- 0,
                                                UserConcept.column_exercise_result_2 <- 0,
                                                UserConcept.column_exercise_result_3 <- 0,
                                                UserConcept.column_exercise_result_4 <- 0,
                                                UserConcept.column_exercise_result_5 <- 0,
                                                UserConcept.column_exercise_result_6 <- 0,
                                                UserConcept.column_latest_result_index <- 6))
    }
    
    func decrementStrengthForUserConcept(conceptID: Int) {
        let userConceptQuery = userConceptsTable.filter(UserConcept.column_conceptID == Int64(conceptID))
        guard let userConceptRow = try? db.pluck(userConceptQuery) else {
            return
        }
        let priorStrength = userConceptRow[UserConcept.column_strength]
        let newStrength = max(priorStrength - 1, 0)
        _ = try? db.run(userConceptQuery.update(UserConcept.column_strength <- newStrength))
    }
    
    func getExercises(forConceptID conceptID: Int) -> [Exercise] {
        let query = exerciseTable.join(conceptsTable, on: conceptsTable[Concept.column_id] == exerciseTable[Exercise.column_conceptID])
                    .filter(Exercise.column_conceptID == Int64(conceptID))

        let result: [Exercise]? = try? db.prepare(query).compactMap { row -> Exercise? in
            return Exercise.createFromQueryResult(row)
        }

        return result ?? [Exercise]()
    }
    
    func getExercise(id: Int) -> Exercise? {
        let query = exerciseTable.join(conceptsTable, on: conceptsTable[Concept.column_id] == exerciseTable[Exercise.column_conceptID])
            .filter(exerciseTable[Exercise.column_id] == Int64(id))
 
        guard let exerciseRow = try? db.pluck(query) else {
            return nil
        }
        
        return Exercise.createFromQueryResult(exerciseRow)
    }
    
    func recordResult(concept_id: Int, correct: Bool) {
        let query = userConceptsTable.filter(UserConcept.column_conceptID == Int64(concept_id))
        
        guard let userConceptRow = try? db.pluck(query) else {
            return
        }
        
        let latestResultIndex = Int(userConceptRow[UserConcept.column_latest_result_index])
        let newResultIndex = (latestResultIndex + 1) % 7
        
        let resultValue: Int64 = correct ? 1 : 0
        let resultColumn = resultColumnFromIndex(newResultIndex)
        let indexColumn = UserConcept.column_latest_result_index
        
        _ = try? db.run(query.update(resultColumn <- resultValue, indexColumn <- Int64(newResultIndex)))
        
//        printCurrentUserConceptStatus(concept_id: concept_id)
    }
    
    private func printCurrentUserConceptStatus(concept_id: Int) {
        let query = userConceptsTable.filter(UserConcept.column_conceptID == Int64(concept_id))
        
        
        
        guard let userConceptRow = try? db.pluck(query) else {
            return
        }
        
        let results = [userConceptRow[UserConcept.column_exercise_result_0],
                       userConceptRow[UserConcept.column_exercise_result_1],
                       userConceptRow[UserConcept.column_exercise_result_2],
                       userConceptRow[UserConcept.column_exercise_result_3],
                       userConceptRow[UserConcept.column_exercise_result_4],
                       userConceptRow[UserConcept.column_exercise_result_5],
                       userConceptRow[UserConcept.column_exercise_result_6] ]
        
        print("latestResultIndex: \(results)")
    }
    
    private func resultColumnFromIndex(_ index: Int) -> Expression<Int64> {
        switch index {
        case 0:
            return UserConcept.column_exercise_result_0
        case 1:
            return UserConcept.column_exercise_result_1
        case 2:
            return UserConcept.column_exercise_result_2
        case 3:
            return UserConcept.column_exercise_result_3
        case 4:
            return UserConcept.column_exercise_result_4
        case 5:
            return UserConcept.column_exercise_result_5
        case 6:
            return UserConcept.column_exercise_result_6
        default:
            return UserConcept.column_exercise_result_0
        }
    }
    
    func getFocusConcepts() -> (Int, Int) {
        let query = User.table.filter(User.column_id == 1)
        
        guard let userRow = try? db.pluck(query) else {
            return (0, 0)
        }
        
        return (0, 0)
    }
    
    func getEnrichedUserConcept(conceptID: Int) -> EnrichedUserConcept? {
        let query = conceptsTable.join(userConceptsTable, on: UserConcept.column_conceptID == conceptsTable[Concept.column_id])
                                .filter(UserConcept.column_conceptID == Int64(conceptID))
        
        guard let userConceptRow = try? db.pluck(query),
            let userConcept = UserConcept.createFromQueryResult(userConceptRow)
        else {
            return nil
        }

        let results = [Int(userConceptRow[UserConcept.column_exercise_result_0]),
                       Int(userConceptRow[UserConcept.column_exercise_result_1]),
                       Int(userConceptRow[UserConcept.column_exercise_result_2]),
                       Int(userConceptRow[UserConcept.column_exercise_result_3]),
                       Int(userConceptRow[UserConcept.column_exercise_result_4]),
                       Int(userConceptRow[UserConcept.column_exercise_result_5]),
                       Int(userConceptRow[UserConcept.column_exercise_result_6]) ]

        let score = results.reduce(0) { $0 + $1 }
        let status = Int(userConceptRow[UserConcept.column_status])

        return EnrichedUserConcept(userConcept: userConcept, statusCode: status, currentScore: score)
    }
    
    func setUserConceptStatus(_ status: Int, forConceptID conceptID: Int) {
        let query = UserConcept.table.filter(UserConcept.column_conceptID == Int64(conceptID))
        _ = try? db.run(query.update(UserConcept.column_status <- Int64(status)))
    }
    
    func setFocusConcepts(concept1: Int, concept2: Int) {
        
    }
    
}
