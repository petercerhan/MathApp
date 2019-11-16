//
//  ConceptGroup+sqlite.swift
//  MathApp
//
//  Created by Peter Cerhan on 11/16/19.
//  Copyright © 2019 Peter Cerhan. All rights reserved.
//

import Foundation
import SQLite

extension ConceptGroup {
    static let table = Table("concept_groups")
    
    static let column_id = Expression<Int64>("id")
    static let column_name = Expression<String>("name")
    
    static func createFromQueryResult(_ row: Row) -> ConceptGroup? {
        let tableName = ConceptGroup.table
        let id = Int(row[tableName[ConceptGroup.column_id]])
        let name = row[tableName[ConceptGroup.column_name]]
        
        return ConceptGroup(id: id, name: name)
    }
}
