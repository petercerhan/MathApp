//
//  UserConceptGroupRepository.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

protocol UserConceptGroupRepository {
    func list() -> [UserConceptGroup]
}

class UserConceptGroupRepositoryImpl: UserConceptGroupRepository {
    
    //MARK: - Dependencies
    
    private let databaseService: DatabaseService
    
    //MARK: - Initialization
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    //MARK: - UserConceptGroupRepository Interface
    
    func list() -> [UserConceptGroup] {
        let query = UserConceptGroup.table.join(ConceptGroup.table, on: UserConceptGroup.column_conceptGroupID == ConceptGroup.table[ConceptGroup.column_id])

        let result: [UserConceptGroup]? = try? databaseService.db.prepare(query).compactMap { row -> UserConceptGroup? in
            return UserConceptGroup.createFromQueryResult(row)
        }
        return result ?? [UserConceptGroup]()
    }
    
    
}
