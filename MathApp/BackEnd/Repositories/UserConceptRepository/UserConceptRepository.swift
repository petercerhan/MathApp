//
//  UserConceptRepository.swift
//  MathApp
//
//  Created by Peter Cerhan on 10/19/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

protocol UserConceptRepository {
    func list(conceptGroupID: Int) -> [UserConcept]
    func get(conceptID: Int) -> UserConcept?
    func set(id: Int, fields: [String: String])
}

class UserConceptRepositoryImpl: UserConceptRepository {
    
    //MARK: - Dependencies
    
    private let databaseService: DatabaseService
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    //MARK: - UserConceptRepository Interface
    
    func list(conceptGroupID: Int) -> [UserConcept] {
        let query = Concept.table.join(UserConcept.table, on: UserConcept.column_conceptID == Concept.table[Concept.column_id])
                            .filter(Concept.column_conceptGroupID == Int64(conceptGroupID))
        let result: [UserConcept]? = try? databaseService.db.prepare(query).compactMap { row -> UserConcept? in
            return UserConcept.createFromQueryResult(row)
        }
        return result ?? [UserConcept]()
    }
    
    func get(conceptID: Int) -> UserConcept? {
        let query = UserConcept.table.join(Concept.table, on: Concept.table[Concept.column_id] == UserConcept.table[UserConcept.column_conceptID])
            .filter(Concept.table[Concept.column_id] == Int64(conceptID))
        
        guard let userConceptRow = try? databaseService.db.pluck(query) else {
            return nil
        }
        
        return UserConcept.createFromQueryResult(userConceptRow)
    }
    
    func set(id: Int, fields: [String: String]) {
        let query = UserConcept.table.filter(UserConcept.column_id == Int64(id))
        
        if let newStrengthData = fields["strength"], let newStrength = Int64(newStrengthData) {
            _ = try? databaseService.db.run(query.update(UserConcept.column_strength <- newStrength))
        }
    }
    
}

