//
//  Concept+sqlite.swift
//  MathApp
//
//  Created by Peter Cerhan on 9/10/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

extension Concept {
    static let table = Table("concepts")
    
    static let column_id = Expression<Int64>("id")
    static let column_name = Expression<String>("name")
    static let column_description = Expression<String>("description")
    static let column_rule = Expression<String>("rule")
    static let column_example = Expression<String>("example")
    static let column_maxDifficulty = Expression<Int64>("maximum_difficulty")
    static let column_conceptGroupID = Expression<Int64>("concept_group_id")
    
    static func createFromQueryResult(_ row: Row) -> Concept? {
        let tableName = Concept.table
        let concept_id = row[tableName[Concept.column_id]]
        let concept_name = row[tableName[Concept.column_name]]
        let concept_description = row[tableName[Concept.column_description]]
        let concept_rule = row[tableName[Concept.column_rule]]
        let concept_example = row[tableName[Concept.column_example]]
        let concept_maxDifficulty = row[tableName[Concept.column_maxDifficulty]]
        
        return Concept(id: Int(concept_id),
                       name: concept_name,
                       description: concept_description,
                       rule: concept_rule,
                       example: concept_example,
                       maxDifficulty: Int(concept_maxDifficulty))
    }
}
