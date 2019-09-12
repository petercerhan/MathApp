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
    func getUserConcepts() -> [UserConcept]
    func incrementStrengthForUserConcept(withID: Int)
    func decrementStrengthForUserConcept(withID conceptID: Int)
    func reset()
}

class DatabaseServiceImpl: DatabaseService {
    
    private var db: Connection!
    
    private lazy var conceptsTable = Concept.table
    private lazy var userConceptsTable = UserConcept.table
    
    func setup() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        guard let db = try? Connection("\(path)/db.sqlite3") else {
            return
        }
        self.db = db

        if !databaseIsSetup() {
            setupTables()
        }
    }
    
    private func databaseIsSetup() -> Bool {
        if let _ = try? db.pluck(conceptsTable) {
            return true
        } else {
            return false
        }
    }
    
    private func setupTables() {
        setupConceptsTable()
        setupUserConceptsTable()
    }
    
    private func setupConceptsTable() {
        _ = try? db.run(Concept.createTableStatement)
        insertConceptsData()
    }
    
    private func insertConceptsData() {
        _ = try? db.run(Concept.constantRule.insertStatement)
        _ = try? db.run(Concept.linearRule.insertStatement)
        _ = try? db.run(Concept.powerRule.insertStatement)
        _ = try? db.run(Concept.sumRule.insertStatement)
        _ = try? db.run(Concept.differenceRule.insertStatement)
    }
    
    private func setupUserConceptsTable() {
        _ = try? db.run(UserConcept.createTableStatement)
        insertUserConceptsData()
    }
    
    private func insertUserConceptsData() {
        _ = try? db.run(UserConcept.constantRule.insertStatement)
        _ = try? db.run(UserConcept.linearRule.insertStatement)
        _ = try? db.run(UserConcept.powerRule.insertStatement)
        _ = try? db.run(UserConcept.sumRule.insertStatement)
        _ = try? db.run(UserConcept.differenceRule.insertStatement)
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
    
    func reset() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: "\(path)/db.sqlite3")
    }
}
