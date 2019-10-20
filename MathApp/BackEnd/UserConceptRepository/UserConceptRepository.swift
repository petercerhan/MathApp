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
    func list(conceptID: Int) -> [UserConcept]
}

class UserConceptRepositoryImpl: UserConceptRepository {
    
    //MARK: - Dependencies
    
    private let databaseService: DatabaseService
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    //MARK: - UserConceptRepository Interface
    
    func list(conceptID: Int) -> [UserConcept] {
        let query = Concept.table.join(UserConcept.table, on: UserConcept.column_conceptID == Concept.table[Concept.column_id])
        let result: [UserConcept]? = try? databaseService.db.prepare(query).compactMap { row -> UserConcept? in
            return UserConcept.createFromQueryResult(row)
        }
        return result ?? [UserConcept]()
    }
    
}
