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
    func list(chapterID: Int) -> [UserConceptGroup]
    func set(id: Int, fields: [String: String])
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
    
    func list(chapterID: Int) -> [UserConceptGroup] {
        let query = UserConceptGroup.table.join(ConceptGroup.table, on: UserConceptGroup.column_conceptGroupID == ConceptGroup.table[ConceptGroup.column_id])
                                            .filter(ConceptGroup.column_chapterID == Int64(chapterID))

        let result: [UserConceptGroup]? = try? databaseService.db.prepare(query).compactMap { row -> UserConceptGroup? in
            return UserConceptGroup.createFromQueryResult(row)
        }
        return result ?? [UserConceptGroup]()
    }
    
    func set(id: Int, fields: [String: String]) {
        let query = UserConceptGroup.table.filter(UserConceptGroup.column_id == Int64(id))
        
        if let completedData = fields["completed"], let completed = Int64(completedData) {
            _ = try? databaseService.db.run(query.update(UserConceptGroup.column_completed <- completed))
        }
    }
    
    
}
