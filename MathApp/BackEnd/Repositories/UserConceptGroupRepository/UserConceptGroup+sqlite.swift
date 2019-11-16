//
//  UserConceptGroup+sqlite.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

extension UserConceptGroup {
    static let table = Table("user_concept_groups")
    
    static let column_id = Expression<Int64>("id")
    static let column_completed = Expression<Int64>("completed")
    
    static func createFromQueryResult(_ row: Row) -> UserConceptGroup? {
        let tableName = UserConceptGroup.table
        let id = Int(row[tableName[UserConceptGroup.column_id]])
        let completedData = Int(row[tableName[UserConceptGroup.column_completed]])
        let completed = (completedData == 1)
        
        guard let conceptGroup = ConceptGroup.createFromQueryResult(row) else {
            return nil
        }
        
        return UserConceptGroup(id: id, completed: completed, conceptGroup: conceptGroup)
    }
}
