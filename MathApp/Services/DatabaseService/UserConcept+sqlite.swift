//
//  UserConcept+sqlite.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/10/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

extension UserConcept {
    static let table = Table("user_concepts")
    
    static let column_id = Expression<Int64>("id")
    static let column_conceptID = Expression<Int64>("concept_id")
    static let column_strength = Expression<Int64>("strength")
    
    static let createTableStatement: String = UserConcept.table.create { table in
                                                table.column(UserConcept.column_id, primaryKey: true)
                                                table.column(UserConcept.column_conceptID)
                                                table.column(UserConcept.column_strength) }
    
    static func createFromQueryResult(_ row: Row) -> UserConcept? {
        let tableName = UserConcept.table
        let id = Int(row[tableName[UserConcept.column_id]])
        let strength = Int(row[tableName[UserConcept.column_strength]])
        
        guard let concept = Concept.createFromQueryResult(row) else {
            return nil
        }
        
        return UserConcept(id: id, concept: concept, strength: strength)
    }
    
    var insertStatement: Insert {
        return UserConcept.table.insert(UserConcept.column_id <- Int64(id),
                                    UserConcept.column_conceptID <- Int64(concept.id),
                                    UserConcept.column_strength <- Int64(strength))
    }
}
