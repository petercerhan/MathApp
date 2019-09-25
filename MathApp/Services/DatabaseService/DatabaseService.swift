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
    func setup()
    func reset()
    
    func getUserConcepts() -> [UserConcept]
    
    func incrementStrengthForUserConcept(withID: Int)
    func decrementStrengthForUserConcept(withID conceptID: Int)
    
    func getExercises(forConceptID conceptID: Int) -> [Exercise]
}

class DatabaseServiceImpl: DatabaseService {
    
    private var db: Connection!
    
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
    
    func getUserConcepts() -> [UserConcept] {
        let query = conceptsTable.join(userConceptsTable, on: UserConcept.column_conceptID == conceptsTable[Concept.column_id])
        let result: [UserConcept]? = try? db.prepare(query).compactMap { row -> UserConcept? in
            return UserConcept.createFromQueryResult(row)
        }
        return result ?? [UserConcept]()
    }
    
    func incrementStrengthForUserConcept(withID conceptID: Int) {
        let userConceptQuery = userConceptsTable.filter(UserConcept.column_conceptID == Int64(conceptID))
        guard let userConceptRow = try? db.pluck(userConceptQuery) else {
            return
        }
        let priorStrength = userConceptRow[UserConcept.column_strength]
        let newStrength = min(priorStrength + 1, 3)
        _ = try? db.run(userConceptQuery.update(UserConcept.column_strength <- newStrength))
    }
    
    func decrementStrengthForUserConcept(withID conceptID: Int) {
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
    
    func reset() {
        removeOldDB()
        setup()
    }
    
    private func removeOldDB() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: "\(path)/\(databaseFilename)")
    }
}
